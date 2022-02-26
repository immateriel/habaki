#include "rb_katana.h"

VALUE rb_Katana, rb_Output, rb_KError, rb_KArray, rb_Stylesheet,
    rb_MediaRule, rb_MediaQuery, rb_MediaQueryExp,
    rb_SupportsRule, rb_SupportsExp,
    rb_PageRule, rb_FontFaceRule, rb_StyleRule, rb_ImportRule, rb_NamespaceRule, rb_CharsetRule,
    rb_Selector, rb_SelectorData, rb_Declaration, rb_Value, rb_QualifiedName, rb_ValueFunction;

void output_free(KatanaOutput *output)
{
  katana_destroy_output(output);
}


VALUE rb_output_stylesheet(VALUE self)
{
  KatanaOutput *c_output;
  Data_Get_Struct(self, KatanaOutput, c_output);

  return Data_Wrap_Struct(rb_Stylesheet, NULL, NULL, c_output->stylesheet);
}

VALUE rb_output_errors(VALUE self)
{
  KatanaOutput *c_output;
  Data_Get_Struct(self, KatanaOutput, c_output);

  VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, &c_output->errors);

  VALUE sing = rb_singleton_class(array);
  rb_define_method(sing, "each", rb_error_each, 0);

  return array;
}

VALUE rb_output_dump(VALUE self)
{
  KatanaOutput *c_output;
  Data_Get_Struct(self, KatanaOutput, c_output);

  katana_dump_output(c_output);
  return Qnil;
}

// Error

VALUE rb_error_first_line(VALUE self)
{
  KatanaError *c_err;
  Data_Get_Struct(self, KatanaError, c_err);
  return INT2NUM(c_err->first_line);
}

VALUE rb_error_first_column(VALUE self)
{
  KatanaError *c_err;
  Data_Get_Struct(self, KatanaError, c_err);
  return INT2NUM(c_err->first_column);
}

VALUE rb_error_last_line(VALUE self)
{
  KatanaError *c_err;
  Data_Get_Struct(self, KatanaError, c_err);
  return INT2NUM(c_err->last_line);
}

VALUE rb_error_last_column(VALUE self)
{
  KatanaError *c_err;
  Data_Get_Struct(self, KatanaError, c_err);
  return INT2NUM(c_err->last_column);
}

VALUE rb_error_message(VALUE self)
{
  KatanaError *c_err;
  Data_Get_Struct(self, KatanaError, c_err);
  return rb_str_new2(c_err->message);
}

VALUE rb_stylesheet_rules(VALUE self)
{
  KatanaStylesheet *c_stylesheet;
  Data_Get_Struct(self, KatanaStylesheet, c_stylesheet);
  VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, &c_stylesheet->rules);

  VALUE sing = rb_singleton_class(array);
  rb_define_method(sing, "each", rb_rule_each, 0);

  return array;
}

VALUE rb_stylesheet_imports(VALUE self)
{
  KatanaStylesheet *c_stylesheet;
  Data_Get_Struct(self, KatanaStylesheet, c_stylesheet);

  VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, &c_stylesheet->imports);

  VALUE sing = rb_singleton_class(array);
  rb_define_method(sing, "each", rb_rule_each, 0);

  return array;
}


/*
* parse CSS data
* @param [String] data
* @return [Katana::Output]
*/
VALUE rb_parse(VALUE self, VALUE data)
{
  KatanaOutput *output = katana_parse(RSTRING_PTR(data), RSTRING_LEN(data), KatanaParserModeStylesheet);

  return Data_Wrap_Struct(rb_Output, NULL, output_free, output);
}

void Init_katana()
{
  /* Low-level parser */
  rb_Katana = rb_define_module("Katana");

  rb_Output = rb_define_class_under(rb_Katana, "Output", rb_cObject);
  rb_define_method(rb_Output, "dump", rb_output_dump, 0);
  rb_define_method(rb_Output, "stylesheet", rb_output_stylesheet, 0);
  rb_define_method(rb_Output, "errors", rb_output_errors, 0);

  // Array
  rb_KArray = rb_define_class_under(rb_Katana, "Array", rb_cObject);
  rb_include_module(rb_KArray, rb_mEnumerable);
  rb_define_method(rb_KArray, "length", rb_array_length, 0);

  // Error
  rb_KError = rb_define_class_under(rb_Katana, "Error", rb_cObject);
  rb_define_method(rb_KError, "first_line", rb_error_first_line, 0);
  rb_define_method(rb_KError, "first_column", rb_error_first_column, 0);
  rb_define_method(rb_KError, "last_line", rb_error_last_line, 0);
  rb_define_method(rb_KError, "last_column", rb_error_last_column, 0);
  rb_define_method(rb_KError, "message", rb_error_message, 0);

  // Stylesheet
  rb_Stylesheet = rb_define_class_under(rb_Katana, "Stylesheet", rb_cObject);
  rb_define_method(rb_Stylesheet, "rules", rb_stylesheet_rules, 0);
  rb_define_method(rb_Stylesheet, "imports", rb_stylesheet_imports, 0);

  // SupportsRule

  rb_SupportsExp = rb_define_class_under(rb_Katana, "SupportsExpression", rb_cObject);
  rb_define_method(rb_SupportsExp, "operation", rb_supports_exp_op, 0);
  rb_define_method(rb_SupportsExp, "expressions", rb_supports_exp_exps, 0);
  rb_define_method(rb_SupportsExp, "declaration", rb_supports_exp_declaration, 0);

  rb_SupportsRule = rb_define_class_under(rb_Katana, "SupportsRule", rb_cObject);
  rb_define_method(rb_SupportsRule, "expression", rb_supports_exp, 0);
  rb_define_method(rb_SupportsRule, "rules", rb_supports_rules, 0);

  // NamespaceRule
  rb_NamespaceRule = rb_define_class_under(rb_Katana, "NamespaceRule", rb_cObject);
  rb_define_method(rb_NamespaceRule, "prefix", rb_namespace_rule_prefix, 0);
  rb_define_method(rb_NamespaceRule, "uri", rb_namespace_rule_uri, 0);

  // MediaRule
  rb_MediaRule = rb_define_class_under(rb_Katana, "MediaRule", rb_cObject);
  rb_define_method(rb_MediaRule, "medias", rb_media_rule_medias, 0);
  rb_define_method(rb_MediaRule, "rules", rb_media_rule_rules, 0);

  // MediaQueryExp
  rb_MediaQueryExp = rb_define_class_under(rb_Katana, "MediaQueryExpression", rb_cObject);
  rb_define_method(rb_MediaQueryExp, "feature", rb_media_query_exp_feature, 0);
  rb_define_method(rb_MediaQueryExp, "values", rb_media_query_exp_values, 0);

  // MediaQuery
  rb_MediaQuery = rb_define_class_under(rb_Katana, "MediaQuery", rb_cObject);
  rb_define_method(rb_MediaQuery, "type", rb_media_query_type, 0);
  rb_define_method(rb_MediaQuery, "restrictor", rb_media_query_restrictor, 0);
  rb_define_method(rb_MediaQuery, "expressions", rb_media_query_expressions, 0);

  // PageRule
  rb_PageRule = rb_define_class_under(rb_Katana, "PageRule", rb_cObject);
  rb_define_method(rb_PageRule, "declarations", rb_page_rule_declarations, 0);

  // FontFaceRule
  rb_FontFaceRule = rb_define_class_under(rb_Katana, "FontFaceRule", rb_cObject);
  rb_define_method(rb_FontFaceRule, "declarations", rb_font_face_rule_declarations, 0);

  // ImportRule
  rb_ImportRule = rb_define_class_under(rb_Katana, "ImportRule", rb_cObject);
  rb_define_method(rb_ImportRule, "href", rb_import_rule_href, 0);
  rb_define_method(rb_ImportRule, "medias", rb_import_rule_medias, 0);

  // CharsetRule
  rb_CharsetRule = rb_define_class_under(rb_Katana, "CharsetRule", rb_cObject);
  rb_define_method(rb_CharsetRule, "encoding", rb_charset_rule_encoding, 0);

  // StyleRule
  rb_StyleRule = rb_define_class_under(rb_Katana, "StyleRule", rb_cObject);
  rb_define_method(rb_StyleRule, "selectors", rb_style_rule_selectors, 0);
  rb_define_method(rb_StyleRule, "declarations", rb_style_rule_declarations, 0);

  // SelectorData
  rb_SelectorData = rb_define_class_under(rb_Katana, "SelectorData", rb_cObject);
  // TODO: bits
  rb_define_method(rb_SelectorData, "value", rb_selector_data_value, 0);
  rb_define_method(rb_SelectorData, "attribute", rb_selector_data_attr, 0);
  rb_define_method(rb_SelectorData, "argument", rb_selector_data_argument, 0);
  rb_define_method(rb_SelectorData, "selectors", rb_selector_data_selectors, 0);

  // Selector
  rb_Selector = rb_define_class_under(rb_Katana, "Selector", rb_cObject);
  rb_define_method(rb_Selector, "specificity", rb_selector_specificity, 0);
  rb_define_method(rb_Selector, "match", rb_selector_match, 0);
  rb_define_method(rb_Selector, "tag", rb_selector_tag, 0);
  rb_define_method(rb_Selector, "relation", rb_selector_relation, 0);
  rb_define_method(rb_Selector, "pseudo", rb_selector_pseudo, 0);
  rb_define_method(rb_Selector, "data", rb_selector_data, 0);
  rb_define_method(rb_Selector, "tag_history", rb_selector_tag_history, 0);

  // Declaration
  rb_Declaration = rb_define_class_under(rb_Katana, "Declaration", rb_cObject);
  rb_define_method(rb_Declaration, "property", rb_declaration_prop, 0);
  rb_define_method(rb_Declaration, "important", rb_declaration_important, 0);
  rb_define_method(rb_Declaration, "values", rb_declaration_values, 0);
  rb_define_method(rb_Declaration, "raw", rb_declaration_raw, 0);

  // Value
  rb_Value = rb_define_class_under(rb_Katana, "Value", rb_cObject);
  rb_define_method(rb_Value, "value", rb_value_value, 0);
  rb_define_method(rb_Value, "unit", rb_value_unit, 0);
  rb_define_method(rb_Value, "raw", rb_value_raw, 0);

  // ValueFunction
  rb_ValueFunction = rb_define_class_under(rb_Katana, "ValueFunction", rb_cObject);
  rb_define_method(rb_ValueFunction, "name", rb_value_function_name, 0);
  rb_define_method(rb_ValueFunction, "args", rb_value_function_args, 0);

  // QualifiedName
  rb_QualifiedName = rb_define_class_under(rb_Katana, "QualifiedName", rb_cObject);
  rb_define_method(rb_QualifiedName, "local", rb_name_local, 0);
  rb_define_method(rb_QualifiedName, "prefix", rb_name_prefix, 0);
  rb_define_method(rb_QualifiedName, "uri", rb_name_uri, 0);

  rb_define_singleton_method(rb_Katana, "parse", rb_parse, 1);
}
