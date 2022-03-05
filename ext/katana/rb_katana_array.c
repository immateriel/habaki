/* 
* Typed each method for Katana::Array
*/
#include "rb_katana.h"

VALUE rb_rule_each(VALUE array)
{
  int i;
  KatanaArray *c_array;
  Data_Get_Struct(array, KatanaArray, c_array);
  for (i = 0; i < c_array->length; i++)
  {
    KatanaRule *rule = (KatanaRule *)c_array->data[i];
    switch (rule->type)
    {
    case KatanaRuleUnkown:
      break;
    case KatanaRuleStyle:
      rb_yield(Data_Wrap_Struct(rb_StyleRule, NULL, NULL, rule));
      break;
    case KatanaRuleImport:
      rb_yield(Data_Wrap_Struct(rb_ImportRule, NULL, NULL, rule));
      break;
    case KatanaRuleMedia:
      rb_yield(Data_Wrap_Struct(rb_MediaRule, NULL, NULL, rule));
      break;
    case KatanaRulePage:
      rb_yield(Data_Wrap_Struct(rb_PageRule, NULL, NULL, rule));
      break;
    case KatanaRuleFontFace:
      rb_yield(Data_Wrap_Struct(rb_FontFaceRule, NULL, NULL, rule));
      break;
    case KatanaRuleSupports:
      rb_yield(Data_Wrap_Struct(rb_SupportsRule, NULL, NULL, rule));
      break;
    case KatanaRuleNamespace:
      rb_yield(Data_Wrap_Struct(rb_NamespaceRule, NULL, NULL, rule));
      break;
    case KatanaRuleCharset:
      rb_yield(Data_Wrap_Struct(rb_CharsetRule, NULL, NULL, rule));
      break;
    case KatanaRuleKeyframes:
      // TODO
      break;
    case KatanaRuleHost:
      // TODO
      break;
    default:
      break;
    }
  }
  return Qnil;
}

VALUE rb_media_query_each(VALUE array)
{
  int i;
  KatanaArray *c_array;
  Data_Get_Struct(array, KatanaArray, c_array);
  for (i = 0; i < c_array->length; i++)
  {
    KatanaMediaQuery *query = (KatanaMediaQuery *)c_array->data[i];
    rb_yield(Data_Wrap_Struct(rb_MediaQuery, NULL, NULL, query));
  }
  return Qnil;
}

VALUE rb_selector_each(VALUE array)
{
  int i;
  KatanaArray *c_array;
  Data_Get_Struct(array, KatanaArray, c_array);
  for (i = 0; i < c_array->length; i++)
  {
    KatanaSelector *selector = (KatanaSelector *)c_array->data[i];
    rb_yield(Data_Wrap_Struct(rb_Selector, NULL, NULL, selector));
  }
  return Qnil;
}

VALUE rb_declaration_each(VALUE array)
{
  int i;
  KatanaArray *c_array;
  Data_Get_Struct(array, KatanaArray, c_array);
  for (i = 0; i < c_array->length; i++)
  {
    KatanaDeclaration *decl = (KatanaDeclaration *)c_array->data[i];
    rb_yield(Data_Wrap_Struct(rb_Declaration, NULL, NULL, decl));
  }
  return Qnil;
}

VALUE rb_value_each(VALUE array)
{
  int i;
  KatanaArray *c_array;
  Data_Get_Struct(array, KatanaArray, c_array);
  for (i = 0; i < c_array->length; i++)
  {
    KatanaValue *value = (KatanaValue *)c_array->data[i];
    rb_yield(Data_Wrap_Struct(rb_Value, NULL, NULL, value));
  }
  return Qnil;
}

VALUE rb_expression_each(VALUE array)
{
  int i;
  KatanaArray *c_array;
  Data_Get_Struct(array, KatanaArray, c_array);
  for (i = 0; i < c_array->length; i++)
  {
    KatanaMediaQueryExp *value = (KatanaMediaQueryExp *)c_array->data[i];
    rb_yield(Data_Wrap_Struct(rb_MediaQueryExp, NULL, NULL, value));
  }
  return Qnil;
}

VALUE rb_supports_expression_each(VALUE array)
{
  int i;
  KatanaArray *c_array;
  Data_Get_Struct(array, KatanaArray, c_array);
  for (i = 0; i < c_array->length; i++)
  {
    KatanaSupportsExp *value = (KatanaSupportsExp *)c_array->data[i];
    rb_yield(Data_Wrap_Struct(rb_SupportsExp, NULL, NULL, value));
  }
  return Qnil;
}

VALUE rb_error_each(VALUE array)
{
  int i;
  KatanaArray *c_array;
  Data_Get_Struct(array, KatanaArray, c_array);
  for (i = 0; i < c_array->length; i++)
  {
    KatanaError *value = (KatanaError *)c_array->data[i];
    rb_yield(Data_Wrap_Struct(rb_KError, NULL, NULL, value));
  }
  return Qnil;
}
