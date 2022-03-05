#include "rb_katana.h"

VALUE rb_Katana, rb_Output, rb_KError, rb_KPosition, rb_KArray, rb_Stylesheet,
    rb_MediaRule, rb_MediaQuery, rb_MediaQueryExp,
    rb_SupportsRule, rb_SupportsExp,
    rb_PageRule, rb_FontFaceRule, rb_StyleRule, rb_ImportRule, rb_NamespaceRule, rb_CharsetRule,
    rb_Selector, rb_SelectorData, rb_Declaration, rb_Value, rb_QualifiedName, rb_ValueFunction;

void output_free(KatanaOutput *output)
{
  katana_destroy_output(output);
}

/*
 * @return [Katana::Stylesheet, nil]
 */
VALUE rb_output_stylesheet(VALUE self)
{
  KatanaOutput *c_output;
  Data_Get_Struct(self, KatanaOutput, c_output);

  if (c_output->stylesheet)
    return Data_Wrap_Struct(rb_Stylesheet, NULL, NULL, c_output->stylesheet);
  else
    return Qnil;
}

/*
 * @return [Katana::Array<Katana::Declaration>, nil]
 */
VALUE rb_output_declarations(VALUE self)
{
  KatanaOutput *c_output;
  Data_Get_Struct(self, KatanaOutput, c_output);

  if (c_output->declarations)
  {
    VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_output->declarations);

    VALUE sing = rb_singleton_class(array);
    rb_define_method(sing, "each", rb_declaration_each, 0);

    return array;
  }
  else
  {
    return Qnil;
  }
}

/*
 * @return [Katana::Array<Katana::Selector>, nil]
 */
VALUE rb_output_selectors(VALUE self)
{
  KatanaOutput *c_output;
  Data_Get_Struct(self, KatanaOutput, c_output);

  if (c_output->selectors)
  {
    VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_output->selectors);

    VALUE sing = rb_singleton_class(array);
    rb_define_method(sing, "each", rb_selector_each, 0);

    return array;
  }
  else
  {
    return Qnil;
  }
}

// Position

/*
 * @return [Integer]
 */
VALUE rb_position_line(VALUE self)
{
    KatanaSourcePosition *c_pos;
    Data_Get_Struct(self, KatanaSourcePosition, c_pos);
    return INT2NUM(c_pos->line);
}

/*
 * @return [Integer]
 */
VALUE rb_position_column(VALUE self)
{
    KatanaSourcePosition *c_pos;
    Data_Get_Struct(self, KatanaSourcePosition, c_pos);
    return INT2NUM(c_pos->column);
}

/*
 * @return [Katana::Array<Katana::Error>]
 */
VALUE rb_output_errors(VALUE self)
{
  KatanaOutput *c_output;
  Data_Get_Struct(self, KatanaOutput, c_output);

  VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, &c_output->errors);

  VALUE sing = rb_singleton_class(array);
  rb_define_method(sing, "each", rb_error_each, 0);

  return array;
}


// Array
/*
* @return [Integer]
*/
VALUE rb_array_length(VALUE array)
{
  KatanaArray *c_array;
  Data_Get_Struct(array, KatanaArray, c_array);
  return INT2NUM(c_array->length);
}


// Error

/*
 * @return [Integer]
 */
VALUE rb_error_first_line(VALUE self)
{
  KatanaError *c_err;
  Data_Get_Struct(self, KatanaError, c_err);
  return INT2NUM(c_err->first_line);
}

/*
 * @return [Integer]
 */
VALUE rb_error_first_column(VALUE self)
{
  KatanaError *c_err;
  Data_Get_Struct(self, KatanaError, c_err);
  return INT2NUM(c_err->first_column);
}

/*
 * @return [Integer]
 */
VALUE rb_error_last_line(VALUE self)
{
  KatanaError *c_err;
  Data_Get_Struct(self, KatanaError, c_err);
  return INT2NUM(c_err->last_line);
}

/*
 * @return [Integer]
 */
VALUE rb_error_last_column(VALUE self)
{
  KatanaError *c_err;
  Data_Get_Struct(self, KatanaError, c_err);
  return INT2NUM(c_err->last_column);
}

/*
 * @return [String]
 */
VALUE rb_error_message(VALUE self)
{
  KatanaError *c_err;
  Data_Get_Struct(self, KatanaError, c_err);
  return rb_str_new2(c_err->message);
}

/*
 * @return [Katana::Array]
 */
VALUE rb_stylesheet_rules(VALUE self)
{
  KatanaStylesheet *c_stylesheet;
  Data_Get_Struct(self, KatanaStylesheet, c_stylesheet);
  VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, &c_stylesheet->rules);

  VALUE sing = rb_singleton_class(array);
  rb_define_method(sing, "each", rb_rule_each, 0);

  return array;
}

/*
 * @return [Katana::Array]
 */
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
 * parse CSS from string
 * @param [String] data
 * @return [Katana::Output]
 */
VALUE rb_parse(VALUE self, VALUE data)
{
  KatanaOutput *output = katana_parse(RSTRING_PTR(data), RSTRING_LEN(data), KatanaParserModeStylesheet);

  return Data_Wrap_Struct(rb_Output, NULL, output_free, output);
}

/*
 * parse CSS inline from string
 * @param [String] data
 * @return [Katana::Output]
 */
VALUE rb_parse_inline(VALUE self, VALUE data)
{
  KatanaOutput *output = katana_parse(RSTRING_PTR(data), RSTRING_LEN(data), KatanaParserModeDeclarationList);

  return Data_Wrap_Struct(rb_Output, NULL, output_free, output);
}

/*
 * parse CSS selector from string
 * @param [String] data
 * @return [Katana::Output]
 */
VALUE rb_parse_selectors(VALUE self, VALUE data)
{
  KatanaOutput *output = katana_parse(RSTRING_PTR(data), RSTRING_LEN(data), KatanaParserModeSelector);

  return Data_Wrap_Struct(rb_Output, NULL, output_free, output);
}

void Init_katana()
{
  /* Low-level parser */
  rb_Katana = rb_define_module("Katana");

  rb_Output = rb_define_class_under(rb_Katana, "Output", rb_cObject);
  rb_define_method(rb_Output, "stylesheet", rb_output_stylesheet, 0);
  rb_define_method(rb_Output, "declarations", rb_output_declarations, 0);
  rb_define_method(rb_Output, "selectors", rb_output_selectors, 0);
  rb_define_method(rb_Output, "errors", rb_output_errors, 0);

  // Array
  rb_KArray = rb_define_class_under(rb_Katana, "Array", rb_cObject);
  rb_include_module(rb_KArray, rb_mEnumerable);
  rb_define_method(rb_KArray, "length", rb_array_length, 0);

  // Source position
  rb_KPosition = rb_define_class_under(rb_Katana, "SourcePosition", rb_cObject);
  rb_define_method(rb_KPosition, "line", rb_position_line, 0);
  rb_define_method(rb_KPosition, "column", rb_position_column, 0);

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

  init_katana_rule();
  init_katana_selector();
  init_katana_declaration();

  // Module method
  rb_define_singleton_method(rb_Katana, "parse", rb_parse, 1);
  rb_define_singleton_method(rb_Katana, "parse_inline", rb_parse_inline, 1);
  rb_define_singleton_method(rb_Katana, "parse_selectors", rb_parse_selectors, 1);
}
