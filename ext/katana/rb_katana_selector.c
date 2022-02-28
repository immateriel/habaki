/*
 * Selectors
 */
#include "rb_katana.h"

extern VALUE rb_Katana, rb_Output, rb_KError, rb_KArray, rb_Stylesheet,
    rb_MediaRule, rb_MediaQuery, rb_MediaQueryExp,
    rb_SupportsRule, rb_SupportsExp,
    rb_PageRule, rb_FontFaceRule, rb_StyleRule, rb_ImportRule, rb_NamespaceRule, rb_CharsetRule,
    rb_Selector, rb_SelectorData, rb_Declaration, rb_Value, rb_QualifiedName, rb_ValueFunction;

// QualifiedName

/*
 * @return [String, nil]
 */
VALUE rb_name_local(VALUE self)
{
  KatanaQualifiedName *c_name;
  Data_Get_Struct(self, KatanaQualifiedName, c_name);
  if (c_name->local)
    return rb_str_new2(c_name->local);
  else
    return Qnil;
}

/*
 * @return [String, nil]
 */
VALUE rb_name_prefix(VALUE self)
{
  KatanaQualifiedName *c_name;
  Data_Get_Struct(self, KatanaQualifiedName, c_name);
  if (c_name->prefix)
    return rb_str_new2(c_name->prefix);
  else
    return Qnil;
}

/*
 * @return [String, nil]
 */
VALUE rb_name_uri(VALUE self)
{
  KatanaQualifiedName *c_name;
  Data_Get_Struct(self, KatanaQualifiedName, c_name);
  if (c_name->uri)
    return rb_str_new2(c_name->uri);
  else
    return Qnil;
}

// Selector

/*
 * @return [Symbol]
 */
VALUE rb_selector_specificity(VALUE self)
{
  KatanaSelector *c_sel;
  Data_Get_Struct(self, KatanaSelector, c_sel);
  return INT2NUM(c_sel->specificity);
}

/*
 * @return [Symbol]
 */
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
    id = rb_intern("undefined");
    break;
  }
  return ID2SYM(id);
}

/*
 * @return [Symbol]
 */
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

/*
 * @return [Symbol]
 */
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

/*
 * @return [Katana::QualifiedName, nil]
 */
VALUE rb_selector_tag(VALUE self)
{
  KatanaSelector *c_sel;
  Data_Get_Struct(self, KatanaSelector, c_sel);
  if (c_sel->tag)
    return Data_Wrap_Struct(rb_QualifiedName, NULL, NULL, c_sel->tag);
  else
    return Qnil;
}

/*
 * @return [Katana::SelectorData, nil]
 */
VALUE rb_selector_data(VALUE self)
{
  KatanaSelector *c_sel;
  Data_Get_Struct(self, KatanaSelector, c_sel);
  if (c_sel->data)
    return Data_Wrap_Struct(rb_SelectorData, NULL, NULL, c_sel->data);
  else
    return Qnil;
}

/*
 * @return [Katana::Selector, nil]
 */
VALUE rb_selector_tag_history(VALUE self)
{
  KatanaSelector *c_sel;
  Data_Get_Struct(self, KatanaSelector, c_sel);
  if (c_sel->tagHistory)
    return Data_Wrap_Struct(rb_Selector, NULL, NULL, c_sel->tagHistory);
  else
    return Qnil;
}

// SelectorData

/*
 * @return [String, nil]
 */
VALUE rb_selector_data_value(VALUE self)
{
  KatanaSelectorRareData *c_sel;
  Data_Get_Struct(self, KatanaSelectorRareData, c_sel);
  if (c_sel->value)
    return rb_str_new2(c_sel->value);
  else
    return Qnil;
}

/*
 * @return [Katana::QualifiedName, nil]
 */
VALUE rb_selector_data_attr(VALUE self)
{
  KatanaSelectorRareData *c_sel;
  Data_Get_Struct(self, KatanaSelectorRareData, c_sel);
  if (c_sel->attribute)
    return Data_Wrap_Struct(rb_QualifiedName, NULL, NULL, c_sel->attribute);
  else
    return Qnil;
}

/*
 * @return [String, nil]
 */
VALUE rb_selector_data_argument(VALUE self)
{
  KatanaSelectorRareData *c_sel;
  Data_Get_Struct(self, KatanaSelectorRareData, c_sel);
  if (c_sel->argument)
    return rb_str_new2(c_sel->argument);
  else
    return Qnil;
}

/*
 * @return [Katana::Array, nil]
 */
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

void init_katana_selector()
{
  // QualifiedName
  rb_QualifiedName = rb_define_class_under(rb_Katana, "QualifiedName", rb_cObject);
  rb_define_method(rb_QualifiedName, "local", rb_name_local, 0);
  rb_define_method(rb_QualifiedName, "prefix", rb_name_prefix, 0);
  rb_define_method(rb_QualifiedName, "uri", rb_name_uri, 0);

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
}