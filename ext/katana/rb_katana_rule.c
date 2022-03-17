#include "rb_katana.h"

// SupportsRule

/*
 * @return [Symbol]
 */
VALUE rb_supports_exp_op(VALUE self)
{
  ID id;
  KatanaSupportsExp *c_exp;
  Data_Get_Struct(self, KatanaSupportsExp, c_exp);

  switch (c_exp->op)
  {
  case KatanaSupportsOperatorNone:
    id = rb_intern("none");
    break;
  case KatanaSupportsOperatorNot:
    id = rb_intern("not");
    break;
  case KatanaSupportsOperatorAnd:
    id = rb_intern("and");
    break;
  case KatanaSupportsOperatorOr:
    id = rb_intern("or");
    break;
  default:
    id = rb_intern("unknown");
    break;
  }
  return ID2SYM(id);
}

VALUE rb_supports_exp_exps(VALUE self)
{
  KatanaSupportsExp *c_exp;
  Data_Get_Struct(self, KatanaSupportsExp, c_exp);

  if (c_exp->exps)
  {
    VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_exp->exps);

    VALUE sing = rb_singleton_class(array);
    rb_define_method(sing, "each", rb_supports_expression_each, 0);

    return array;
  }
  else
    return Qnil;
}

VALUE rb_supports_exp_declaration(VALUE self)
{
  KatanaSupportsExp *c_exp;
  Data_Get_Struct(self, KatanaSupportsExp, c_exp);
  if (c_exp->decl)
  {
    VALUE array = Data_Wrap_Struct(rb_Declaration, NULL, NULL, c_exp->decl);
  }
  else
    return Qnil;
}

VALUE rb_supports_rules(VALUE self)
{
  KatanaSupportsRule *c_rule;
  Data_Get_Struct(self, KatanaSupportsRule, c_rule);

  if (c_rule->rules)
  {
    VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_rule->rules);

    VALUE sing = rb_singleton_class(array);
    rb_define_method(sing, "each", rb_rule_each, 0);

    return array;
  }
  else
    return Qnil;
}

VALUE rb_supports_exp(VALUE self)
{
  KatanaSupportsRule *c_rule;
  Data_Get_Struct(self, KatanaSupportsRule, c_rule);

  if (c_rule->exp)
  {
    VALUE exp = Data_Wrap_Struct(rb_SupportsExp, NULL, NULL, c_rule->exp);
    return exp;
  }
  else
    return Qnil;
}

// NamespaceRule

/*
 * @return [String, nil]
 */
VALUE rb_namespace_rule_prefix(VALUE self)
{
  KatanaNamespaceRule *c_rule;
  Data_Get_Struct(self, KatanaNamespaceRule, c_rule);
  if (c_rule->prefix)
    return UTF8_STR_NEW(c_rule->prefix);
  else
    return Qnil;
}

/*
 * @return [String, nil]
 */
VALUE rb_namespace_rule_uri(VALUE self)
{
  KatanaNamespaceRule *c_rule;
  Data_Get_Struct(self, KatanaNamespaceRule, c_rule);
  if (c_rule->prefix)
    return UTF8_STR_NEW(c_rule->uri);
  else
    return Qnil;
}

// MediaRule

/*
 * @return [Katana::Array]
 */
VALUE rb_media_rule_rules(VALUE self)
{
  KatanaMediaRule *c_media_rule;
  Data_Get_Struct(self, KatanaMediaRule, c_media_rule);

  if (c_media_rule->rules)
  {
    VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_media_rule->rules);

    VALUE sing = rb_singleton_class(array);
    rb_define_method(sing, "each", rb_rule_each, 0);

    return array;
  }
  else
    return Qnil;
}

/*
 * @return [Katana::Array<Katana::MediaQuery>]
 */
VALUE rb_media_rule_medias(VALUE self)
{
  KatanaMediaRule *c_media_rule;
  Data_Get_Struct(self, KatanaMediaRule, c_media_rule);

  if (c_media_rule->medias)
  {
    VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_media_rule->medias);
    VALUE sing = rb_singleton_class(array);
    rb_define_method(sing, "each", rb_media_query_each, 0);

    return array;
  }
  else
    return Qnil;
}

// MediaQueryExp

/*
 * @return [String, nil]
 */
VALUE rb_media_query_exp_feature(VALUE self)
{
  KatanaMediaQueryExp *c_query;
  Data_Get_Struct(self, KatanaMediaQueryExp, c_query);
  if (c_query->feature)
    return rb_str_new2(c_query->feature);
  else
    return Qnil;
}

/*
 * @return [Katana::Array<Katana::Value>, nil]
 */
VALUE rb_media_query_exp_values(VALUE self)
{
  KatanaMediaQueryExp *c_query;
  Data_Get_Struct(self, KatanaMediaQueryExp, c_query);

  if (c_query->values)
  {
    VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_query->values);

    VALUE sing = rb_singleton_class(array);
    rb_define_method(sing, "each", rb_value_each, 0);

    return array;
  }
  else
    return Qnil;
}

// MediaQuery

/*
 * @return [String]
 */
VALUE rb_media_query_type(VALUE self)
{
  KatanaMediaQuery *c_query;
  Data_Get_Struct(self, KatanaMediaQuery, c_query);
  if (c_query->type)
    return rb_str_new2(c_query->type);
  else
    return Qnil;
}

/*
 * @return [Symbol]
 */
VALUE rb_media_query_restrictor(VALUE self)
{
  ID id;
  KatanaMediaQuery *c_query;
  Data_Get_Struct(self, KatanaMediaQuery, c_query);
  switch (c_query->restrictor)
  {
  case KatanaMediaQueryRestrictorNone:
    id = rb_intern("none");
    break;
  case KatanaMediaQueryRestrictorOnly:
    id = rb_intern("only");
    break;
  case KatanaMediaQueryRestrictorNot:
    id = rb_intern("not");
    break;
  default:
    id = rb_intern("undefined");
    break;
  }
  return ID2SYM(id);
}

/*
 * @return [Katana::Array<Katana::MediaQueryExpression>]
 */
VALUE rb_media_query_expressions(VALUE self)
{
  KatanaMediaQuery *c_query;
  Data_Get_Struct(self, KatanaMediaQuery, c_query);

  if (c_query->expressions)
  {
    VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_query->expressions);

    VALUE sing = rb_singleton_class(array);
    rb_define_method(sing, "each", rb_expression_each, 0);

    return array;
  }
  else
    return Qnil;
}

// PageRule

/*
 * @return [Katana::Array<Katana::Declaration>]
 */
VALUE rb_page_rule_declarations(VALUE self)
{
  KatanaPageRule *c_rule;
  Data_Get_Struct(self, KatanaPageRule, c_rule);

  if (c_rule->declarations)
  {
    VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_rule->declarations);

    VALUE sing = rb_singleton_class(array);
    rb_define_method(sing, "each", rb_declaration_each, 0);

    return array;
  }
  else
    return Qnil;
}

// FontFaceRule

/*
 * @return [Katana::Array<Katana::Declaration>]
 */
VALUE rb_font_face_rule_declarations(VALUE self)
{
  KatanaFontFaceRule *c_rule;
  Data_Get_Struct(self, KatanaFontFaceRule, c_rule);

  if (c_rule->declarations)
  {
    VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_rule->declarations);

    VALUE sing = rb_singleton_class(array);
    rb_define_method(sing, "each", rb_declaration_each, 0);

    return array;
  }
  else
    return Qnil;
}

// ImportRule

/*
 * @return [String]
 */
VALUE rb_import_rule_href(VALUE self)
{
  KatanaImportRule *c_rule;
  Data_Get_Struct(self, KatanaImportRule, c_rule);
  if (c_rule->href)
    return rb_str_new2(c_rule->href);
  else
    return Qnil;
}

/*
 * @return [Katana::Array<Katana::MediaQuery>]
 */
VALUE rb_import_rule_medias(VALUE self)
{
  KatanaImportRule *c_rule;
  Data_Get_Struct(self, KatanaImportRule, c_rule);

  if (c_rule->medias)
  {
    VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_rule->medias);

    VALUE sing = rb_singleton_class(array);
    rb_define_method(sing, "each", rb_media_query_each, 0);

    return array;
  }
  else
    return Qnil;
}

// CharsetRule

/*
 * @return [String]
 */
VALUE rb_charset_rule_encoding(VALUE self)
{
  KatanaCharsetRule *c_rule;
  Data_Get_Struct(self, KatanaCharsetRule, c_rule);
  if (c_rule->encoding)
    return rb_str_new2(c_rule->encoding);
  else
    return Qnil;
}

// StyleRule

/*
 * @return [Katana::Array<Katana::Selector>]
 */
VALUE rb_style_rule_selectors(VALUE self)
{
  KatanaStyleRule *c_style_rule;
  Data_Get_Struct(self, KatanaStyleRule, c_style_rule);

  if (c_style_rule->selectors)
  {
    VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_style_rule->selectors);

    VALUE sing = rb_singleton_class(array);
    rb_define_method(sing, "each", rb_selector_each, 0);

    return array;
  }
  else
    return Qnil;
}

/*
 * @return [Katana::Array<Katana::Declaration>]
 */
VALUE rb_style_rule_declarations(VALUE self)
{
  KatanaStyleRule *c_style_rule;
  Data_Get_Struct(self, KatanaStyleRule, c_style_rule);

  if (c_style_rule->declarations)
  {
    VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_style_rule->declarations);

    VALUE sing = rb_singleton_class(array);
    rb_define_method(sing, "each", rb_declaration_each, 0);

    return array;
  }
  else
    return Qnil;
}

void init_katana_rule()
{
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
}