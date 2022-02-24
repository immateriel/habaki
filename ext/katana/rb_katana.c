
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <fcntl.h> /*open,close*/
#include <sys/types.h>
#include <unistd.h> /*open,read,close*/
#include <string.h> /*strerror*/
#include <errno.h>
#include <assert.h>

#include <ruby.h>
#include <ruby/io.h>

#include "src/katana.h"
#include "src/selector.h"

VALUE rb_Katana, rb_Output, rb_KError, rb_KArray, rb_Stylesheet,
    rb_MediaRule, rb_MediaQuery, rb_MediaQueryExp,
    rb_SupportsRule,
    rb_PageRule, rb_FontFaceRule, rb_StyleRule, rb_ImportRule, rb_NamespaceRule,
    rb_Selector, rb_SelectorData, rb_Declaration, rb_Value, rb_QualifiedName, rb_ValueFunction;

void output_free(KatanaOutput *output)
{
  katana_destroy_output(output);
}

VALUE rb_array_length(VALUE array)
{
  KatanaArray *c_array;
  Data_Get_Struct(array, KatanaArray, c_array);
  return INT2NUM(c_array->length);
}

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
      // TODO
      break;
    case KatanaRuleNamespace:
      rb_yield(Data_Wrap_Struct(rb_NamespaceRule, NULL, NULL, rule));
      break;
    case KatanaRuleKeyframes:
      // TODO
      break;
    case KatanaRuleCharset:
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

// Selector

VALUE rb_selector_specificity(VALUE self)
{
  KatanaSelector *c_sel;
  Data_Get_Struct(self, KatanaSelector, c_sel);
  return INT2NUM(c_sel->specificity);
}

VALUE rb_selector_match(VALUE self)
{
  ID id;
  KatanaSelector *c_sel;
  Data_Get_Struct(self, KatanaSelector, c_sel);
  switch (c_sel->match)
  {
  case KatanaSelectorMatchUnknown:
    id = rb_intern("unknown");
    break;
  case KatanaSelectorMatchTag:
    id = rb_intern("tag");
    break;
  case KatanaSelectorMatchId:
    id = rb_intern("id");
    break;
  case KatanaSelectorMatchClass:
    id = rb_intern("class");
    break;
  case KatanaSelectorMatchPseudoClass:
    id = rb_intern("pseudo_class");
    break;
  case KatanaSelectorMatchPseudoElement:
    id = rb_intern("pseudo_element");
    break;
  case KatanaSelectorMatchPagePseudoClass:
    id = rb_intern("page_pseudo_class");
    break;
  case KatanaSelectorMatchAttributeExact:
    id = rb_intern("attribute_exact");
    break;
  case KatanaSelectorMatchAttributeSet:
    id = rb_intern("attribute_set");
    break;
  case KatanaSelectorMatchAttributeList:
    id = rb_intern("attribute_list");
    break;
  case KatanaSelectorMatchAttributeHyphen:
    id = rb_intern("attribute_hyphen");
    break;
  case KatanaSelectorMatchAttributeContain:
    id = rb_intern("attribute_contain");
    break;
  case KatanaSelectorMatchAttributeBegin:
    id = rb_intern("attribute_begin");
    break;
  case KatanaSelectorMatchAttributeEnd:
    id = rb_intern("attribute_end");
    break;
  default:
    id = rb_intern("unknown");
    break;
  }
  return ID2SYM(id);
}

VALUE rb_selector_relation(VALUE self)
{
  ID id;
  KatanaSelector *c_sel;
  Data_Get_Struct(self, KatanaSelector, c_sel);
  switch (c_sel->relation)
  {
  case KatanaSelectorRelationSubSelector:
    id = rb_intern("sub_selector");
    break;
  case KatanaSelectorRelationDescendant:
    id = rb_intern("descendant");
    break;
  case KatanaSelectorRelationChild:
    id = rb_intern("child");
    break;
  case KatanaSelectorRelationDirectAdjacent:
    id = rb_intern("direct_adjacent");
    break;
  case KatanaSelectorRelationIndirectAdjacent:
    id = rb_intern("indirect_adjacent");
    break;
  case KatanaSelectorRelationShadowPseudo:
    id = rb_intern("shadow_pseudo");
    break;
  case KatanaSelectorRelationShadowDeep:
    id = rb_intern("shadow_deep");
    break;
  default:
    id = rb_intern("unknown");
    break;
  }
  return ID2SYM(id);
}

VALUE rb_selector_pseudo(VALUE self)
{
  ID id;
  KatanaSelector *c_sel;
  Data_Get_Struct(self, KatanaSelector, c_sel);
  switch (c_sel->pseudo)
  {
  case KatanaPseudoNotParsed:
    id = rb_intern("not_parsed");
    break;
  case KatanaPseudoUnknown:
    id = rb_intern("unknown");
    break;
  case KatanaPseudoEmpty:
    id = rb_intern("empty");
    break;
  case KatanaPseudoFirstChild:
    id = rb_intern("first_child");
    break;
  case KatanaPseudoFirstOfType:
    id = rb_intern("first_of_type");
    break;
  case KatanaPseudoLastChild:
    id = rb_intern("last_child");
    break;
  case KatanaPseudoLastOfType:
    id = rb_intern("last_of_type");
    break;
  case KatanaPseudoOnlyChild:
    id = rb_intern("only_child");
    break;
  case KatanaPseudoOnlyOfType:
    id = rb_intern("only_of_type");
    break;
  case KatanaPseudoFirstLine:
    id = rb_intern("first_line");
    break;
  case KatanaPseudoFirstLetter:
    id = rb_intern("first_letter");
    break;
  case KatanaPseudoNthChild:
    id = rb_intern("nth_child");
    break;
  case KatanaPseudoNthOfType:
    id = rb_intern("nth_of_type");
    break;
  case KatanaPseudoNthLastChild:
    id = rb_intern("nth_last_child");
    break;
  case KatanaPseudoNthLastOfType:
    id = rb_intern("nth_last_of_type");
    break;
  case KatanaPseudoLink:
    id = rb_intern("link");
    break;
  case KatanaPseudoVisited:
    id = rb_intern("visited");
    break;
  case KatanaPseudoAny:
    id = rb_intern("any");
    break;
  case KatanaPseudoAnyLink:
    id = rb_intern("any_link");
    break;
  case KatanaPseudoAutofill:
    id = rb_intern("autofill");
    break;
  case KatanaPseudoHover:
    id = rb_intern("hover");
    break;
  case KatanaPseudoDrag:
    id = rb_intern("drag");
    break;
  case KatanaPseudoFocus:
    id = rb_intern("focus");
    break;
  case KatanaPseudoActive:
    id = rb_intern("active");
    break;
  case KatanaPseudoChecked:
    id = rb_intern("checked");
    break;
  case KatanaPseudoEnabled:
    id = rb_intern("enabled");
    break;
  case KatanaPseudoFullPageMedia:
    id = rb_intern("full_page_media");
    break;
  case KatanaPseudoDefault:
    id = rb_intern("default");
    break;
  case KatanaPseudoDisabled:
    id = rb_intern("disabled");
    break;
  case KatanaPseudoOptional:
    id = rb_intern("optional");
    break;
  case KatanaPseudoRequired:
    id = rb_intern("required");
    break;
  case KatanaPseudoReadOnly:
    id = rb_intern("read_only");
    break;
  case KatanaPseudoReadWrite:
    id = rb_intern("read_write");
    break;
  case KatanaPseudoValid:
    id = rb_intern("valid");
    break;
  case KatanaPseudoInvalid:
    id = rb_intern("invalid");
    break;
  case KatanaPseudoIndeterminate:
    id = rb_intern("indeterminate");
    break;
  case KatanaPseudoTarget:
    id = rb_intern("target");
    break;
  case KatanaPseudoBefore:
    id = rb_intern("before");
    break;
  case KatanaPseudoAfter:
    id = rb_intern("after");
    break;
  case KatanaPseudoBackdrop:
    id = rb_intern("backdrop");
    break;
  case KatanaPseudoLang:
    id = rb_intern("lang");
    break;
  case KatanaPseudoNot:
    id = rb_intern("not");
    break;
  case KatanaPseudoResizer:
    id = rb_intern("resizer");
    break;
  case KatanaPseudoRoot:
    id = rb_intern("root");
    break;
  case KatanaPseudoScope:
    id = rb_intern("scope");
    break;
  case KatanaPseudoScrollbar:
    id = rb_intern("scrollbar");
    break;
  case KatanaPseudoScrollbarButton:
    id = rb_intern("scrollbar_button");
    break;
  case KatanaPseudoScrollbarCorner:
    id = rb_intern("scrollbar_corner");
    break;
  case KatanaPseudoScrollbarThumb:
    id = rb_intern("scrollbar_thumb");
    break;
  case KatanaPseudoScrollbarTrack:
    id = rb_intern("scrollbar_track");
    break;
  case KatanaPseudoScrollbarTrackPiece:
    id = rb_intern("scrollbar_track_piece");
    break;
  case KatanaPseudoWindowInactive:
    id = rb_intern("window_inactive");
    break;
  case KatanaPseudoCornerPresent:
    id = rb_intern("corner_present");
    break;
  case KatanaPseudoDecrement:
    id = rb_intern("decrement");
    break;
  case KatanaPseudoIncrement:
    id = rb_intern("increment");
    break;
  case KatanaPseudoHorizontal:
    id = rb_intern("horizontal");
    break;
  case KatanaPseudoVertical:
    id = rb_intern("vertical");
    break;
  case KatanaPseudoStart:
    id = rb_intern("start");
    break;
  case KatanaPseudoEnd:
    id = rb_intern("end");
    break;
  case KatanaPseudoDoubleButton:
    id = rb_intern("double_button");
    break;
  case KatanaPseudoSingleButton:
    id = rb_intern("single_button");
    break;
  case KatanaPseudoNoButton:
    id = rb_intern("no_button");
    break;
  case KatanaPseudoSelection:
    id = rb_intern("selection");
    break;
  case KatanaPseudoLeftPage:
    id = rb_intern("left_page");
    break;
  case KatanaPseudoRightPage:
    id = rb_intern("right_page");
    break;
  case KatanaPseudoFirstPage:
    id = rb_intern("first_page");
    break;
  case KatanaPseudoFullScreen:
    id = rb_intern("full_screen");
    break;
  case KatanaPseudoFullScreenDocument:
    id = rb_intern("full_screen_document");
    break;
  case KatanaPseudoFullScreenAncestor:
    id = rb_intern("full_screen_ancestor");
    break;
  case KatanaPseudoInRange:
    id = rb_intern("in_range");
    break;
  case KatanaPseudoOutOfRange:
    id = rb_intern("out_of_range");
    break;
  case KatanaPseudoWebKitCustomElement:
    id = rb_intern("web_kit_custom_element");
    break;
  case KatanaPseudoCue:
    id = rb_intern("cue");
    break;
  case KatanaPseudoFutureCue:
    id = rb_intern("future_cue");
    break;
  case KatanaPseudoPastCue:
    id = rb_intern("past_cue");
    break;
  case KatanaPseudoUnresolved:
    id = rb_intern("unresolved");
    break;
  case KatanaPseudoContent:
    id = rb_intern("content");
    break;
  case KatanaPseudoHost:
    id = rb_intern("host");
    break;
  case KatanaPseudoHostContext:
    id = rb_intern("host_context");
    break;
  case KatanaPseudoShadow:
    id = rb_intern("shadow");
    break;
  case KatanaPseudoSpatialNavigationFocus:
    id = rb_intern("spatial_navigation_focus");
    break;
  case KatanaPseudoListBox:
    id = rb_intern("list_box");
    break;
  default:
    id = rb_intern("unknown");
    break;
  }
  return ID2SYM(id);
}

VALUE rb_selector_tag(VALUE self)
{
  KatanaSelector *c_sel;
  Data_Get_Struct(self, KatanaSelector, c_sel);
  if (c_sel->tag)
    return Data_Wrap_Struct(rb_QualifiedName, NULL, NULL, c_sel->tag);
  else
    return Qnil;
}

VALUE rb_selector_data(VALUE self)
{
  KatanaSelector *c_sel;
  Data_Get_Struct(self, KatanaSelector, c_sel);
  if (c_sel->data)
    return Data_Wrap_Struct(rb_SelectorData, NULL, NULL, c_sel->data);
  else
    return Qnil;
}

VALUE rb_selector_tag_history(VALUE self)
{
  KatanaSelector *c_sel;
  Data_Get_Struct(self, KatanaSelector, c_sel);
  if (c_sel->tagHistory)
    return Data_Wrap_Struct(rb_Selector, NULL, NULL, c_sel->tagHistory);
  else
    return Qnil;
}

VALUE rb_selector_to_s(VALUE self)
{
  KatanaParser parser;
  parser.options = &kKatanaDefaultOptions;

  KatanaSelector *c_sel;
  Data_Get_Struct(self, KatanaSelector, c_sel);
  KatanaParserString *string = katana_selector_to_string(&parser, c_sel, NULL);
  const char *text = katana_string_to_characters(&parser, string);
  return rb_str_new2(text);
}

// SelectorData

VALUE rb_selector_data_value(VALUE self)
{
  KatanaSelectorRareData *c_sel;
  Data_Get_Struct(self, KatanaSelectorRareData, c_sel);
  if (c_sel->value)
    return rb_str_new2(c_sel->value);
  else
    return Qnil;
}

VALUE rb_selector_data_attr(VALUE self)
{
  KatanaSelectorRareData *c_sel;
  Data_Get_Struct(self, KatanaSelectorRareData, c_sel);
  if (c_sel->attribute)
    return Data_Wrap_Struct(rb_QualifiedName, NULL, NULL, c_sel->attribute);
  else
    return Qnil;
}

VALUE rb_selector_data_argument(VALUE self)
{
  KatanaSelectorRareData *c_sel;
  Data_Get_Struct(self, KatanaSelectorRareData, c_sel);
  if (c_sel->argument)
    return rb_str_new2(c_sel->argument);
  else
    return Qnil;
}

VALUE rb_selector_data_selectors(VALUE self)
{
  KatanaSelectorRareData *c_sel;
  Data_Get_Struct(self, KatanaSelectorRareData, c_sel);

  if (c_sel->selectors)
  {
    VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_sel->selectors);

    VALUE sing = rb_singleton_class(array);
    rb_define_method(sing, "each", rb_selector_each, 0);

    return array;
  }
  else
  {
    return Qnil;
  }
}

// Declaration

VALUE rb_declaration_prop(VALUE self)
{
  KatanaDeclaration *c_decl;
  Data_Get_Struct(self, KatanaDeclaration, c_decl);
  return rb_str_new2(c_decl->property);
}

VALUE rb_declaration_important(VALUE self)
{
  KatanaDeclaration *c_decl;
  Data_Get_Struct(self, KatanaDeclaration, c_decl);
  if (c_decl->important)
    return Qtrue;
  else
    return Qfalse;
}

VALUE rb_declaration_raw(VALUE self)
{
  KatanaDeclaration *c_decl;
  Data_Get_Struct(self, KatanaDeclaration, c_decl);
  if (c_decl->raw)
    return rb_str_new2(c_decl->raw);
  else
    return Qnil;
}

// Value

VALUE rb_value_raw(VALUE self)
{
  KatanaValue *c_val;
  Data_Get_Struct(self, KatanaValue, c_val);
  if (c_val->raw)
    return rb_str_new2(c_val->raw);
  else
    return Qnil;
}

VALUE rb_value_unit(VALUE self)
{
  ID id;
  KatanaValue *c_val;
  Data_Get_Struct(self, KatanaValue, c_val);
  switch (c_val->unit)
  {
  case KATANA_VALUE_UNKNOWN:
    id = rb_intern("unknown");
    break;
  case KATANA_VALUE_NUMBER:
    id = rb_intern("number");
    break;
  case KATANA_VALUE_PERCENTAGE:
    id = rb_intern("percentage");
    break;
  case KATANA_VALUE_EMS:
    id = rb_intern("em");
    break;
  case KATANA_VALUE_EXS:
    id = rb_intern("ex");
    break;
  case KATANA_VALUE_PX:
    id = rb_intern("px");
    break;
  case KATANA_VALUE_CM:
    id = rb_intern("cm");
    break;
  case KATANA_VALUE_MM:
    id = rb_intern("mm");
    break;
  case KATANA_VALUE_IN:
    id = rb_intern("in");
    break;
  case KATANA_VALUE_PT:
    id = rb_intern("pt");
    break;
  case KATANA_VALUE_PC:
    id = rb_intern("pc");
    break;
  case KATANA_VALUE_DEG:
    id = rb_intern("deg");
    break;
  case KATANA_VALUE_RAD:
    id = rb_intern("rad");
    break;
  case KATANA_VALUE_GRAD:
    id = rb_intern("grad");
    break;
  case KATANA_VALUE_MS:
    id = rb_intern("ms");
    break;
  case KATANA_VALUE_S:
    id = rb_intern("s");
    break;
  case KATANA_VALUE_HZ:
    id = rb_intern("hz");
    break;
  case KATANA_VALUE_KHZ:
    id = rb_intern("khz");
    break;
  case KATANA_VALUE_DIMENSION:
    id = rb_intern("dimension");
    break;
  case KATANA_VALUE_STRING:
    id = rb_intern("string");
    break;
  case KATANA_VALUE_URI:
    id = rb_intern("uri");
    break;
  case KATANA_VALUE_IDENT:
    id = rb_intern("ident");
    break;
  case KATANA_VALUE_ATTR:
    id = rb_intern("attr");
    break;
  case KATANA_VALUE_COUNTER:
    id = rb_intern("counter");
    break;
  case KATANA_VALUE_RECT:
    id = rb_intern("rect");
    break;
  case KATANA_VALUE_RGBCOLOR:
    id = rb_intern("rgbcolor");
    break;
  case KATANA_VALUE_VW:
    id = rb_intern("vw");
    break;
  case KATANA_VALUE_VH:
    id = rb_intern("vh");
    break;
  case KATANA_VALUE_VMIN:
    id = rb_intern("vmin");
    break;
  case KATANA_VALUE_VMAX:
    id = rb_intern("vmax");
    break;
  case KATANA_VALUE_DPPX:
    id = rb_intern("dppx");
    break;
  case KATANA_VALUE_DPI:
    id = rb_intern("dpi");
    break;
  case KATANA_VALUE_DPCM:
    id = rb_intern("dpcm");
    break;
  case KATANA_VALUE_FR:
    id = rb_intern("fr");
    break;
  case KATANA_VALUE_UNICODE_RANGE:
    id = rb_intern("unicode_range");
    break;
  case KATANA_VALUE_PARSER_OPERATOR:
    id = rb_intern("parser_operator");
    break;
  case KATANA_VALUE_PARSER_INTEGER:
    id = rb_intern("parser_integer");
    break;
  case KATANA_VALUE_PARSER_HEXCOLOR:
    id = rb_intern("parser_hexcolor");
    break;
  case KATANA_VALUE_PARSER_FUNCTION:
    id = rb_intern("parser_function");
    break;
  case KATANA_VALUE_PARSER_LIST:
    id = rb_intern("parser_list");
    break;
  case KATANA_VALUE_PARSER_Q_EMS:
    id = rb_intern("parser_q_ems");
    break;
  case KATANA_VALUE_PARSER_IDENTIFIER:
    id = rb_intern("parser_identifier");
    break;
  case KATANA_VALUE_TURN:
    id = rb_intern("turn");
    break;
  case KATANA_VALUE_REMS:
    id = rb_intern("rem");
    break;
  case KATANA_VALUE_CHS:
    id = rb_intern("ch");
    break;
  case KATANA_VALUE_COUNTER_NAME:
    id = rb_intern("counter_name");
    break;
  case KATANA_VALUE_SHAPE:
    id = rb_intern("shape");
    break;
  case KATANA_VALUE_QUAD:
    id = rb_intern("quad");
    break;
  case KATANA_VALUE_CALC:
    id = rb_intern("calc");
    break;
  case KATANA_VALUE_CALC_PERCENTAGE_WITH_NUMBER:
    id = rb_intern("calc_percentage_with_number");
    break;
  case KATANA_VALUE_CALC_PERCENTAGE_WITH_LENGTH:
    id = rb_intern("calc_percentage_with_length");
    break;
  case KATANA_VALUE_VARIABLE_NAME:
    id = rb_intern("variable_name");
    break;
  case KATANA_VALUE_PROPERTY_ID:
    id = rb_intern("property_id");
    break;
  case KATANA_VALUE_VALUE_ID:
    id = rb_intern("value_id");
    break;
  default:
    id = rb_intern("unknown");
    break;
  }
  return ID2SYM(id);
}

VALUE rb_value_value(VALUE self)
{
  VALUE val = Qnil;
  KatanaValue *c_val;
  Data_Get_Struct(self, KatanaValue, c_val);
  switch (c_val->unit)
  {
  case KATANA_VALUE_NUMBER:
  case KATANA_VALUE_PERCENTAGE:
  case KATANA_VALUE_EMS:
  case KATANA_VALUE_EXS:
  case KATANA_VALUE_REMS:
  case KATANA_VALUE_CHS:
  case KATANA_VALUE_PX:
  case KATANA_VALUE_CM:
  case KATANA_VALUE_DPPX:
  case KATANA_VALUE_DPI:
  case KATANA_VALUE_DPCM:
  case KATANA_VALUE_MM:
  case KATANA_VALUE_IN:
  case KATANA_VALUE_PT:
  case KATANA_VALUE_PC:
  case KATANA_VALUE_DEG:
  case KATANA_VALUE_RAD:
  case KATANA_VALUE_GRAD:
  case KATANA_VALUE_MS:
  case KATANA_VALUE_S:
  case KATANA_VALUE_HZ:
  case KATANA_VALUE_KHZ:
  case KATANA_VALUE_TURN:
  case KATANA_VALUE_VW:
  case KATANA_VALUE_VH:
  case KATANA_VALUE_VMIN:
  case KATANA_VALUE_VMAX:
    // printf("KATANA: %s %d %f\n", c_val->raw, c_val->iValue, c_val->fValue);
    // val = rb_str_new2(c_val->raw);
    val = rb_float_new(c_val->fValue);
    break;
  case KATANA_VALUE_IDENT:
    val = rb_str_new2(c_val->string);
    break;
  case KATANA_VALUE_STRING:
    val = rb_str_new2(c_val->string);
    break;
  case KATANA_VALUE_PARSER_FUNCTION:
  {
    val = Data_Wrap_Struct(rb_ValueFunction, NULL, NULL, c_val->function);
    break;
  }
  case KATANA_VALUE_PARSER_OPERATOR:
    val = rb_sprintf("%c", c_val->iValue);
    break;
  case KATANA_VALUE_PARSER_LIST:
    // TODO
    // return katana_stringify_value_list(parser, value->list);
    break;
  case KATANA_VALUE_PARSER_HEXCOLOR:
    val = rb_str_new2(c_val->string);
    break;
  case KATANA_VALUE_URI:
    val = rb_str_new2(c_val->string);
    break;
  case KATANA_VALUE_UNICODE_RANGE:
    val = rb_str_new2(c_val->string);
    break;
  default:
    fprintf(stderr, "KATANA: unsupported value unit %d (%s)\n", c_val->unit, c_val->raw);
    break;
  }

  return val;
}

// QualifiedName

VALUE rb_name_local(VALUE self)
{
  KatanaQualifiedName *c_name;
  Data_Get_Struct(self, KatanaQualifiedName, c_name);
  if (c_name->local)
    return rb_str_new2(c_name->local);
  else
    return Qnil;
}

VALUE rb_name_prefix(VALUE self)
{
  KatanaQualifiedName *c_name;
  Data_Get_Struct(self, KatanaQualifiedName, c_name);
  if (c_name->prefix)
    return rb_str_new2(c_name->prefix);
  else
    return Qnil;
}

VALUE rb_name_uri(VALUE self)
{
  KatanaQualifiedName *c_name;
  Data_Get_Struct(self, KatanaQualifiedName, c_name);
  if (c_name->uri)
    return rb_str_new2(c_name->uri);
  else
    return Qnil;
}

// ValueFunction

VALUE rb_value_function_name(VALUE self)
{
  KatanaValueFunction *c_val;
  Data_Get_Struct(self, KatanaValueFunction, c_val);
  if (c_val->name)
    return rb_str_new2(c_val->name);
  else
    return Qnil;
}

VALUE rb_value_function_args(VALUE self)
{
  KatanaValueFunction *c_val;
  Data_Get_Struct(self, KatanaValueFunction, c_val);
  if (c_val->args)
  {
    VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_val->args);

    VALUE sing = rb_singleton_class(array);
    rb_define_method(sing, "each", rb_value_each, 0);

    return array;
  }
  else
    return Qnil;
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
  VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_media_rule->rules);

  VALUE sing = rb_singleton_class(array);
  rb_define_method(sing, "each", rb_rule_each, 0);

  return array;
}

VALUE rb_media_rule_medias(VALUE self)
{
  KatanaMediaRule *c_media_rule;
  Data_Get_Struct(self, KatanaMediaRule, c_media_rule);
  VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_media_rule->medias);

  VALUE sing = rb_singleton_class(array);
  rb_define_method(sing, "each", rb_media_query_each, 0);

  return array;
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
  VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_query->values);

  VALUE sing = rb_singleton_class(array);
  rb_define_method(sing, "each", rb_value_each, 0);

  return array;
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
    id = rb_intern("unknown");
    break;
  }
  return ID2SYM(id);
}

VALUE rb_media_query_expressions(VALUE self)
{
  KatanaMediaQuery *c_query;
  Data_Get_Struct(self, KatanaMediaQuery, c_query);
  VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_query->expressions);

  VALUE sing = rb_singleton_class(array);
  rb_define_method(sing, "each", rb_expression_each, 0);

  return array;
}

// PageRule

VALUE rb_page_rule_declarations(VALUE self)
{
  KatanaPageRule *c_rule;
  Data_Get_Struct(self, KatanaPageRule, c_rule);
  VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_rule->declarations);

  VALUE sing = rb_singleton_class(array);
  rb_define_method(sing, "each", rb_declaration_each, 0);

  return array;
}

// FontFaceRule

VALUE rb_font_face_rule_declarations(VALUE self)
{
  KatanaFontFaceRule *c_rule;
  Data_Get_Struct(self, KatanaFontFaceRule, c_rule);
  VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_rule->declarations);

  VALUE sing = rb_singleton_class(array);
  rb_define_method(sing, "each", rb_declaration_each, 0);

  return array;
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
  VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_rule->medias);

  VALUE sing = rb_singleton_class(array);
  rb_define_method(sing, "each", rb_media_query_each, 0);

  return array;
}

// StyleRule

VALUE rb_style_rule_selectors(VALUE self)
{
  KatanaStyleRule *c_style_rule;
  Data_Get_Struct(self, KatanaStyleRule, c_style_rule);
  VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_style_rule->selectors);

  VALUE sing = rb_singleton_class(array);
  rb_define_method(sing, "each", rb_selector_each, 0);

  return array;
}

VALUE rb_style_rule_declarations(VALUE self)
{
  KatanaStyleRule *c_style_rule;
  Data_Get_Struct(self, KatanaStyleRule, c_style_rule);
  VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_style_rule->declarations);

  VALUE sing = rb_singleton_class(array);
  rb_define_method(sing, "each", rb_declaration_each, 0);

  return array;
}

VALUE rb_declaration_values(VALUE self)
{
  KatanaDeclaration *c_declaration;
  Data_Get_Struct(self, KatanaDeclaration, c_declaration);
  VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_declaration->values);

  VALUE sing = rb_singleton_class(array);
  rb_define_method(sing, "each", rb_value_each, 0);

  return array;
}

VALUE rb_parse(VALUE self, VALUE data)
{
  KatanaOutput *output = katana_parse(RSTRING_PTR(data), RSTRING_LEN(data), KatanaParserModeStylesheet);

  return Data_Wrap_Struct(rb_Output, NULL, output_free, output);
}

void Init_katana()
{
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
  // TODO
  rb_SupportsRule = rb_define_class_under(rb_Katana, "SupportsRule", rb_cObject);

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
  rb_define_method(rb_Selector, "to_s", rb_selector_to_s, 0);

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
