#ifndef RB_KATANA_H
#define RB_KATANA_H
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

/* Array */

VALUE rb_array_length(VALUE array);
VALUE rb_rule_each(VALUE array);
VALUE rb_media_query_each(VALUE array);
VALUE rb_selector_each(VALUE array);
VALUE rb_declaration_each(VALUE array);
VALUE rb_value_each(VALUE array);
VALUE rb_expression_each(VALUE array);
VALUE rb_supports_expression_each(VALUE array);
VALUE rb_error_each(VALUE array);

/* Selector */

VALUE rb_selector_specificity(VALUE self);
VALUE rb_selector_match(VALUE self);
VALUE rb_selector_relation(VALUE self);
VALUE rb_selector_pseudo(VALUE self);
VALUE rb_selector_tag(VALUE self);
VALUE rb_selector_data(VALUE self);
VALUE rb_selector_tag_history(VALUE self);
VALUE rb_selector_data_value(VALUE self);
VALUE rb_selector_data_attr(VALUE self);
VALUE rb_selector_data_argument(VALUE self);
VALUE rb_selector_data_selectors(VALUE self);

/* Declaration */

VALUE rb_declaration_prop(VALUE self);
VALUE rb_declaration_important(VALUE self);
VALUE rb_declaration_values(VALUE self);

VALUE rb_value_unit(VALUE self);
VALUE rb_value_value(VALUE self);
VALUE rb_value_function_name(VALUE self);
VALUE rb_value_function_args(VALUE self);

VALUE rb_name_local(VALUE self);
VALUE rb_name_prefix(VALUE self);
VALUE rb_name_uri(VALUE self);

/* Rule */

VALUE rb_supports_exp_op(VALUE self);
VALUE rb_supports_exp_exps(VALUE self);
VALUE rb_supports_exp_declaration(VALUE self);
VALUE rb_supports_rules(VALUE self);
VALUE rb_supports_exp(VALUE self);

VALUE rb_namespace_rule_prefix(VALUE self);
VALUE rb_namespace_rule_uri(VALUE self);

VALUE rb_media_rule_rules(VALUE self);
VALUE rb_media_rule_medias(VALUE self);
VALUE rb_media_query_exp_feature(VALUE self);
VALUE rb_media_query_exp_values(VALUE self);
VALUE rb_media_query_type(VALUE self);
VALUE rb_media_query_restrictor(VALUE self);
VALUE rb_media_query_expressions(VALUE self);

VALUE rb_page_rule_declarations(VALUE self);

VALUE rb_font_face_rule_declarations(VALUE self);

VALUE rb_import_rule_href(VALUE self);
VALUE rb_import_rule_medias(VALUE self);

VALUE rb_charset_rule_encoding(VALUE self);

VALUE rb_style_rule_selectors(VALUE self);
VALUE rb_style_rule_declarations(VALUE self);

void init_katana_rule();
void init_katana_selector();
void init_katana_declaration();

extern VALUE rb_Katana, rb_Output, rb_KError, rb_KPosition, rb_KArray, rb_Stylesheet,
    rb_MediaRule, rb_MediaQuery, rb_MediaQueryExp,
    rb_SupportsRule, rb_SupportsExp,
    rb_PageRule, rb_FontFaceRule, rb_StyleRule, rb_ImportRule, rb_NamespaceRule, rb_CharsetRule,
    rb_Selector, rb_SelectorData, rb_Declaration, rb_Value, rb_QualifiedName, rb_ValueFunction;

#endif

