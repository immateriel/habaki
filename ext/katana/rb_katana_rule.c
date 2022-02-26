#include "rb_katana.h"

extern VALUE rb_Katana, rb_Output, rb_KError, rb_KArray, rb_Stylesheet,
    rb_MediaRule, rb_MediaQuery, rb_MediaQueryExp,
    rb_SupportsRule, rb_SupportsExp,
    rb_PageRule, rb_FontFaceRule, rb_StyleRule, rb_ImportRule, rb_NamespaceRule,
    rb_Selector, rb_SelectorData, rb_Declaration, rb_Value, rb_QualifiedName, rb_ValueFunction;

// SupportsRule

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
  {
    return Qnil;
  }
}

VALUE rb_supports_exp_declaration(VALUE self)
{
  KatanaSupportsExp *c_exp;
  Data_Get_Struct(self, KatanaSupportsExp, c_exp);
  if(c_exp->decl) {
    VALUE array = Data_Wrap_Struct(rb_Declaration, NULL, NULL, c_exp->decl);
  } else {
    return Qnil;
  }
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
  {
    return Qnil;
  }
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
  {
    return Qnil;
  }
}

// NamespaceRule
VALUE rb_namespace_rule_prefix(VALUE self)
{
  KatanaNamespaceRule *c_rule;
  Data_Get_Struct(self, KatanaNamespaceRule, c_rule);
  if (c_rule->prefix)
    return rb_str_new2(c_rule->prefix);
  else
    return Qnil;
}

VALUE rb_namespace_rule_uri(VALUE self)
{
  KatanaNamespaceRule *c_rule;
  Data_Get_Struct(self, KatanaNamespaceRule, c_rule);
  if (c_rule->prefix)
    return rb_str_new2(c_rule->uri);
  else
    return Qnil;
}

// MediaRule

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
  {
    return Qnil;
  }
}

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
  {
    return Qnil;
  }
}

// MediaQueryExp

VALUE rb_media_query_exp_feature(VALUE self)
{
  KatanaMediaQueryExp *c_query;
  Data_Get_Struct(self, KatanaMediaQueryExp, c_query);
  if (c_query->feature)
    return rb_str_new2(c_query->feature);
  else
    return Qnil;
}

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
  {
    return Qnil;
  }
}

// MediaQuery

VALUE rb_media_query_type(VALUE self)
{
  KatanaMediaQuery *c_query;
  Data_Get_Struct(self, KatanaMediaQuery, c_query);
  if (c_query->type)
    return rb_str_new2(c_query->type);
  else
    return Qnil;
}

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
  {
    return Qnil;
  }
}

// PageRule

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
  {
    return Qnil;
  }
}

// FontFaceRule

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
  {
    return Qnil;
  }
}

// ImportRule

VALUE rb_import_rule_href(VALUE self)
{
  KatanaImportRule *c_rule;
  Data_Get_Struct(self, KatanaImportRule, c_rule);
  if (c_rule->href)
    return rb_str_new2(c_rule->href);
  else
    return Qnil;
}

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
  {
    return Qnil;
  }
}

// StyleRule

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
  {
    return Qnil;
  }
}

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
  {
    return Qnil;
  }
}
