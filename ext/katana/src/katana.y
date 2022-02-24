%code requires {

/*
 *  Copyright (C) 2002-2003 Lars Knoll (knoll@kde.org)
 *  Copyright (C) 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013 Apple Inc. All rights reserved.
 *  Copyright (C) 2006 Alexey Proskuryakov (ap@nypop.com)
 *  Copyright (C) 2008 Eric Seidel <eric@webkit.org>
 *  Copyright (C) 2012 Intel Corporation. All rights reserved.
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */

#include "foundation.h"
#include "katana.h"
#include <string.h>

#define YYENABLE_NLS 0
#define YYLTYPE_IS_TRIVIAL 1
#define YYMAXDEPTH 10000
#define YYDEBUG 0

}

%{
  #include "tokenizer.h"
%}

%define api.prefix {katana}

//%pure-parser
%locations
%define api.pure full

%parse-param { void* scanner}
%parse-param { struct KatanaInternalParser * parser }
%lex-param { void* scanner}
%lex-param { struct KatanaInternalParser * parser }

%union {
    
    bool boolean;
    char character;
    int integer;
    KatanaParserNumber number;
    KatanaParserString string;

    KatanaRule* rule;
    // The content of the three below HeapVectors are guaranteed to be kept alive by
    // the corresponding parsedRules, floatingMediaQueryExpList, and parsedKeyFrames
    // lists
    KatanaArray* ruleList;
    KatanaArray* mediaQueryExpList;
    KatanaArray* keyframeRuleList;

    KatanaSelector* selector;
    KatanaArray* selectorList;
    // CSSSelector::MarginBoxType marginBox;
    KatanaSelectorRelation relation;
    KatanaAttributeMatchType attributeMatchType;
    KatanaArray* mediaList;
    KatanaMediaQuery* mediaQuery;
    KatanaMediaQueryRestrictor mediaQueryRestrictor;
    KatanaMediaQueryExp* mediaQueryExp;
    KatanaValue* value;
    KatanaArray* valueList;
    KatanaKeyframe* keyframe;
    KatanaSourcePosition* location;

    KatanaSupportsExp* supportsExp;
}

%{

%}

%expect 0

%nonassoc LOWEST_PREC

%left UNIMPORTANT_TOK

%token KATANA_CSS_WHITESPACE KATANA_CSS_SGML_CD
%token TOKEN_EOF 0

%token KATANA_CSS_INCLUDES
%token KATANA_CSS_DASHMATCH
%token KATANA_CSS_BEGINSWITH
%token KATANA_CSS_ENDSWITH
%token KATANA_CSS_CONTAINS

%token <string> KATANA_CSS_STRING
%right <string> KATANA_CSS_IDENT
%token <string> KATANA_CSS_NTH

%nonassoc <string> KATANA_CSS_HEX
%nonassoc <string> KATANA_CSS_IDSEL
%nonassoc ':'
%nonassoc '.'
%nonassoc '['
%nonassoc <string> '*'
%nonassoc error
%left '|'

%token KATANA_CSS_IMPORT_SYM
%token KATANA_CSS_PAGE_SYM
%token KATANA_CSS_MEDIA_SYM
%token KATANA_CSS_SUPPORTS_SYM
%token KATANA_CSS_FONT_FACE_SYM
%token KATANA_CSS_CHARSET_SYM
%token KATANA_CSS_NAMESPACE_SYM
%token KATANA_CSS_VIEWPORT_RULE_SYM
%token KATANA_INTERNAL_DECLS_SYM
%token KATANA_INTERNAL_MEDIALIST_SYM
%token KATANA_INTERNAL_RULE_SYM
%token KATANA_INTERNAL_SELECTOR_SYM
%token KATANA_INTERNAL_VALUE_SYM
%token KATANA_INTERNAL_KEYFRAME_RULE_SYM
%token KATANA_INTERNAL_KEYFRAME_KEY_LIST_SYM
%token KATANA_INTERNAL_SUPPORTS_CONDITION_SYM
%token KATANA_CSS_KEYFRAMES_SYM
%token KATANA_CSS_WEBKIT_KATANA_CSS_KEYFRAMES_SYM
%token <marginBox> TOPLEFTCORNER_SYM
%token <marginBox> TOPLEFT_SYM
%token <marginBox> TOPCENTER_SYM
%token <marginBox> TOPRIGHT_SYM
%token <marginBox> TOPRIGHTCORNER_SYM
%token <marginBox> BOTTOMLEFTCORNER_SYM
%token <marginBox> BOTTOMLEFT_SYM
%token <marginBox> BOTTOMCENTER_SYM
%token <marginBox> BOTTOMRIGHT_SYM
%token <marginBox> BOTTOMRIGHTCORNER_SYM
%token <marginBox> LEFTTOP_SYM
%token <marginBox> LEFTMIDDLE_SYM
%token <marginBox> LEFTBOTTOM_SYM
%token <marginBox> RIGHTTOP_SYM
%token <marginBox> RIGHTMIDDLE_SYM
%token <marginBox> RIGHTBOTTOM_SYM

%token KATANA_CSS_ATKEYWORD

%token KATANA_CSS_IMPORTANT_SYM
%token KATANA_CSS_MEDIA_ONLY
%token KATANA_CSS_MEDIA_NOT
%token KATANA_CSS_MEDIA_AND
%token KATANA_CSS_MEDIA_OR

%token KATANA_CSS_SUPPORTS_NOT
%token KATANA_CSS_SUPPORTS_AND
%token KATANA_CSS_SUPPORTS_OR

%token <number> KATANA_CSS_REMS
%token <number> KATANA_CSS_CHS
%token <number> KATANA_CSS_QEMS
%token <number> KATANA_CSS_EMS
%token <number> KATANA_CSS_EXS
%token <number> KATANA_CSS_PXS
%token <number> KATANA_CSS_CMS
%token <number> KATANA_CSS_MMS
%token <number> KATANA_CSS_INS
%token <number> KATANA_CSS_PTS
%token <number> KATANA_CSS_PCS
%token <number> KATANA_CSS_DEGS
%token <number> KATANA_CSS_RADS
%token <number> KATANA_CSS_GRADS
%token <number> KATANA_CSS_TURNS
%token <number> KATANA_CSS_MSECS
%token <number> KATANA_CSS_SECS
%token <number> KATANA_CSS_HERTZ
%token <number> KATANA_CSS_KHERTZ
%token <string> KATANA_CSS_DIMEN
%token <string> KATANA_CSS_INVALIDDIMEN
%token <number> KATANA_CSS_PERCENTAGE
%token <number> KATANA_CSS_FLOATTOKEN
%token <number> KATANA_CSS_INTEGER
%token <number> KATANA_CSS_VW
%token <number> KATANA_CSS_VH
%token <number> KATANA_CSS_VMIN
%token <number> KATANA_CSS_VMAX
%token <number> KATANA_CSS_DPPX
%token <number> KATANA_CSS_DPI
%token <number> KATANA_CSS_DPCM
%token <number> KATANA_CSS_FR

%token <string> KATANA_CSS_URI
%token <string> KATANA_CSS_FUNCTION
%token <string> KATANA_CSS_ANYFUNCTION
%token <string> KATANA_CSS_CUEFUNCTION
%token <string> KATANA_CSS_NOTFUNCTION
%token <string> KATANA_CSS_DISTRIBUTEDFUNCTION
%token <string> KATANA_CSS_CALCFUNCTION
%token <string> KATANA_CSS_MINFUNCTION // missing
%token <string> KATANA_CSS_MAXFUNCTION // missing
%token <string> KATANA_CSS_HOSTFUNCTION
%token <string> KATANA_CSS_HOSTCONTEXTFUNCTION

%token <string> KATANA_CSS_UNICODERANGE

%type <relation> combinator

%type <rule> ruleset
%type <rule> media
%type <rule> import
%type <rule> namespace
%type <rule> page
%type <rule> margin_box
%type <rule> font_face
%type <rule> keyframes
%type <rule> rule
%type <rule> valid_rule
%type <ruleList> block_rule_body
%type <ruleList> block_rule_list
%type <rule> block_rule
%type <rule> block_valid_rule
%type <rule> supports
%type <rule> viewport
%type <boolean> keyframes_rule_start

%type <string> maybe_ns_prefix

%type <string> namespace_selector

%type <string> string_or_uri
%type <string> ident_or_string
%type <string> medium
%type <marginBox> margin_sym

%type <mediaList> media_list
%type <mediaList> maybe_media_list
%type <mediaList> mq_list
%type <mediaQuery> media_query
%type <mediaQuery> valid_media_query
%type <mediaQueryRestrictor> maybe_media_restrictor
%type <valueList> maybe_media_value
%type <mediaQueryExp> media_query_exp
%type <mediaQueryExpList> media_query_exp_list
%type <mediaQueryExpList> maybe_and_media_query_exp_list

%type <supportsExp> supports_condition
%type <supportsExp> supports_condition_in_parens
%type <supportsExp> supports_negation
%type <supportsExp> supports_conjunction
%type <supportsExp> supports_disjunction
%type <supportsExp> supports_declaration_condition

%type <string> webkit_keyframe_name
%type <keyframe> keyframe_rule
%type <keyframeRuleList> keyframes_rule
%type <keyframeRuleList> keyframe_rule_list
%type <valueList> key_list
%type <value> key

%type <string> property

%type <selector> specifier
%type <selector> specifier_list
%type <selector> simple_selector
%type <selector> selector
%type <selectorList> selector_list
%type <selectorList> simple_selector_list
%type <selector> class
%type <selector> attrib
%type <selector> pseudo
%type <selector> pseudo_page
%type <selector> page_selector

%type <boolean> declaration_list
%type <boolean> decl_list
%type <boolean> declaration
%type <boolean> declarations_and_margins

%type <boolean> prio

%type <integer> match
%type <integer> unary_operator
%type <integer> maybe_unary_operator
%type <character> operator
%type <character> slash_operator

%type <valueList> expr
%type <value> term
%type <value> unary_term
%type <value> function
%type <value> calc_func_term
%type <character> calc_func_operator
%type <valueList> calc_func_expr
%type <valueList> calc_func_paren_expr
%type <value> calc_function

%type <string> element_name
%type <string> attr_name

%type <attributeMatchType> attr_match_type
%type <attributeMatchType> maybe_attr_match_type

%type <location> error_location

%type <valueList> ident_list
%type <value> track_names_list

%%

stylesheet:
    maybe_charset maybe_sgml rule_list
  | internal_decls
  | internal_rule
  | internal_selector
  | internal_medialist
  | internal_value
  | internal_keyframe_rule
  | internal_keyframe_key_list
/*  | internal_supports_condition */
  ;

internal_rule:
    KATANA_INTERNAL_RULE_SYM maybe_space valid_rule maybe_space TOKEN_EOF {
        katana_parse_internal_rule(parser, $3);
    }
;

internal_keyframe_rule:
    KATANA_INTERNAL_KEYFRAME_RULE_SYM maybe_space keyframe_rule maybe_space TOKEN_EOF {
        katana_parse_internal_keyframe_rule(parser, $3);
    }
;

internal_keyframe_key_list:
    KATANA_INTERNAL_KEYFRAME_KEY_LIST_SYM maybe_space key_list TOKEN_EOF {
        katana_parse_internal_keyframe_key_list(parser, $3);
    }
;

internal_decls:
    KATANA_INTERNAL_DECLS_SYM maybe_space_before_declaration declaration_list TOKEN_EOF {
        /* can be empty */
        katana_parse_internal_declaration_list(parser, $3);
    }
;

internal_value:
    KATANA_INTERNAL_VALUE_SYM maybe_space expr TOKEN_EOF {
        katana_parse_internal_value(parser, $3);
    }
;

internal_selector:
    KATANA_INTERNAL_SELECTOR_SYM maybe_space selector_list TOKEN_EOF {
        katana_parse_internal_selector(parser, $3);
    }
;


internal_medialist:
    KATANA_INTERNAL_MEDIALIST_SYM maybe_space location_label maybe_media_list TOKEN_EOF {
        katana_parse_internal_media_list(parser, $4);
    }
;

/*
internal_supports_condition:
    KATANA_INTERNAL_SUPPORTS_CONDITION_SYM maybe_space supports_condition TOKEN_EOF {
       // parser->m_supportsCondition = $3;
    }
;
*/

space:
    KATANA_CSS_WHITESPACE
  | space KATANA_CSS_WHITESPACE
  ;

maybe_space:
    /* empty */ %prec UNIMPORTANT_TOK
  | space
  ;

maybe_sgml:
    /* empty */
  | maybe_sgml KATANA_CSS_SGML_CD
  | maybe_sgml KATANA_CSS_WHITESPACE
  ;

closing_brace:
    '}'
  | %prec LOWEST_PREC TOKEN_EOF
  ;

closing_parenthesis:
    ')'
  | %prec LOWEST_PREC TOKEN_EOF
  ;

closing_square_bracket:
    ']'
  | %prec LOWEST_PREC TOKEN_EOF
  ;

semi_or_eof:
    ';'
  | TOKEN_EOF
  ;

maybe_charset:
    /* empty */
  | KATANA_CSS_CHARSET_SYM maybe_space KATANA_CSS_STRING maybe_space semi_or_eof
  {
      /* create a charset rule and push to stylesheet rules */
      katana_set_charset(parser, &$3);
  }
  | KATANA_CSS_CHARSET_SYM at_rule_recovery
  ;

rule_list:
   /* empty */
 | rule_list rule maybe_sgml {
     if ($2)
         katana_add_rule(parser, $2);
 }
 ;

valid_rule:
    ruleset
  | media
  | page
  | font_face
  | keyframes
  | namespace
  | import
  | supports
  | viewport
  ;

before_rule:
    /* empty */ {
      katana_start_rule(parser);
    }
  ;

rule:
    before_rule valid_rule {
        $$ = $2;
        // parser->m_hadSyntacticallyValidCSSRule = true;
        katana_end_rule(parser, !!$$);
    }
  | before_rule invalid_rule {
        $$ = 0;
        katana_end_rule(parser, false);
    }
  ;

block_rule_body:
    block_rule_list
  | block_rule_list block_rule_recovery
    ;

block_rule_list:
    /* empty */ { $$ = 0; }
  | block_rule_list block_rule maybe_sgml {
      $$ = katana_rule_list_add(parser, $2, $1);
    }
    ;

block_rule_recovery:
    before_rule invalid_rule_header {
        katana_end_rule(parser, false);
    }
  ;

block_valid_rule:
    ruleset
  | page
  | font_face
  | media
  | keyframes
  | supports
  | viewport
  | namespace
  ;

block_rule:
    before_rule block_valid_rule {
        $$ = $2;
        katana_end_rule(parser, !!$$);
    }
  | before_rule invalid_rule {
        $$ = 0;
        katana_end_rule(parser, false);
    }
  ;

before_import_rule:
    /* empty */ {
      katana_start_rule_header(parser, KatanaRuleImport);
    }
    ;

import_rule_start:
    before_import_rule KATANA_CSS_IMPORT_SYM maybe_space {
        katana_end_rule_header(parser);
        katana_start_rule_body(parser);
    }
  ;

import:
    import_rule_start string_or_uri maybe_space location_label maybe_media_list semi_or_eof {
        $$ = katana_new_import_rule(parser, &$2, $5);
    }
  | import_rule_start string_or_uri maybe_space location_label maybe_media_list invalid_block {
        $$ = 0;
    }
  ;

namespace:
    KATANA_CSS_NAMESPACE_SYM maybe_space maybe_ns_prefix string_or_uri maybe_space semi_or_eof {
        $$ = katana_new_namespace_rule(parser, &$3, &$4);
    }
  ;

maybe_ns_prefix:
/* empty */ { $$ = (KatanaParserString){"", 0}; }
| KATANA_CSS_IDENT maybe_space
;

string_or_uri:
KATANA_CSS_STRING
| KATANA_CSS_URI
;

maybe_media_value:
    /*empty*/ {
        $$ = 0;
    }
    | ':' maybe_space expr {
        $$ = $3;
    }
    ;

media_query_exp:
    '(' maybe_space KATANA_CSS_IDENT maybe_space maybe_media_value closing_parenthesis {
        katana_string_to_lowercase(parser, &$3);
        $$ = katana_new_media_query_exp(parser, &$3, $5);
        if (!$$)
            YYERROR;
    }
    | '(' error error_recovery closing_parenthesis {
        YYERROR;
    }
    ;

media_query_exp_list:
    media_query_exp {
        $$ = katana_new_media_query_exp_list(parser);
        katana_media_query_exp_list_add(parser, $1, $$);   
    }
    | media_query_exp_list maybe_space KATANA_CSS_MEDIA_AND maybe_space media_query_exp {
        $$ = $1;
        katana_media_query_exp_list_add(parser, $5, $$);   
    }
    ;

maybe_and_media_query_exp_list:
    maybe_space {
        $$ = katana_new_media_query_exp_list(parser);
    }
    | maybe_space KATANA_CSS_MEDIA_AND maybe_space media_query_exp_list maybe_space {
        $$ = $4;
    }
    ;

maybe_media_restrictor:
    /*empty*/ {
        $$ = KatanaMediaQueryRestrictorNone;
    }
    | KATANA_CSS_MEDIA_ONLY maybe_space {
        $$ = KatanaMediaQueryRestrictorOnly;
    }
    | KATANA_CSS_MEDIA_NOT maybe_space {
        $$ = KatanaMediaQueryRestrictorNot;
    }
    ;

valid_media_query:
    media_query_exp_list maybe_space {
        $$ = katana_new_media_query(parser, KatanaMediaQueryRestrictorNone, NULL, $1);
    }
    | maybe_media_restrictor medium maybe_and_media_query_exp_list {
        katana_string_to_lowercase(parser, &$2);
        (yyval.mediaQuery) = katana_new_media_query(parser, $1, &$2, $3);
    }
    ;

media_query:
    valid_media_query
    | valid_media_query error error_location rule_error_recovery {
        katana_parser_report_error(parser, $3, "parser->lastLocationLabel(), InvalidMediaQueryCSSError");
        $$ = katana_new_media_query(parser, KatanaMediaQueryRestrictorNot, NULL, NULL);
    }
    | error error_location rule_error_recovery {
        katana_parser_report_error(parser, $2, "parser->lastLocationLabel(), InvalidMediaQueryCSSError");
        $$ = katana_new_media_query(parser, KatanaMediaQueryRestrictorNot, NULL, NULL);
    }
    ;

maybe_media_list:
    /* empty */ {
        $$ = katana_new_media_list(parser);
    }
    | media_list
    ;

media_list:
    media_query {
        $$ =  katana_new_media_list(parser);
        katana_media_list_add(parser, $1, $$);
    }
    | mq_list media_query {
        $$ = $1;
        katana_media_list_add(parser, $2, $$);
    }
    | mq_list {
        $$ = $1;
        // $$->addMediaQuery(parser->sinkFloatingMediaQuery(parser->createFloatingNotAllQuery()));
        katana_parser_log(parser, "createFloatingNotAllQuery");
    }
    ;

mq_list:
    media_query ',' maybe_space location_label {
        $$ = katana_new_media_list(parser);
        katana_media_list_add(parser, $1, $$);
    }
    | mq_list media_query ',' maybe_space location_label {
        $$ = $1;
        katana_media_list_add(parser, $2, $$);
    }
    ;

at_rule_body_start:
    /* empty */ {
        katana_start_rule_body(parser);
    }
    ;

before_media_rule:
    /* empty */ {
      katana_start_rule_header(parser, KatanaRuleMedia);
    }
    ;

at_rule_header_end_maybe_space:
    maybe_space {
        katana_end_rule_header(parser);
    }
    ;

media_rule_start:
    KATANA_CSS_MEDIA_SYM maybe_space before_media_rule;

media:
    media_rule_start maybe_media_list '{' at_rule_header_end at_rule_body_start maybe_space block_rule_body closing_brace {
        $$ = katana_new_media_rule(parser, $2, $7);
    }
    ;

medium:
  KATANA_CSS_IDENT
  ;

supports:
    before_supports_rule KATANA_CSS_SUPPORTS_SYM maybe_space supports_condition at_supports_rule_header_end '{' at_rule_body_start maybe_space block_rule_body closing_brace {
        // $$ = parser->createSupportsRule($4, $9);
        $$ = katana_new_supports_rule(parser, $4, $9);
    }
    ;

before_supports_rule:
    /* empty */ {
      katana_start_rule_header(parser, KatanaRuleSupports);
        // parser->startRuleHeader(StyleRule::Supports);
        // parser->markSupportsRuleHeaderStart();
    }
    ;

at_supports_rule_header_end:
    /* empty */ {
        katana_end_rule_header(parser);
        // parser->endRuleHeader();
        // parser->markSupportsRuleHeaderEnd();
    }
    ;

supports_condition:
    supports_condition_in_parens
    | supports_negation
    | supports_conjunction
    | supports_disjunction
    ;

supports_negation:
    KATANA_CSS_SUPPORTS_NOT maybe_space supports_condition_in_parens {
        // $$ = !$3;
        $$ = katana_new_supports_exp(parser, KatanaSupportsOperatorNot);
        katana_supports_exp_list_add(parser, $3, $$->exps);
    }
    ;

supports_conjunction:
    supports_condition_in_parens KATANA_CSS_SUPPORTS_AND maybe_space supports_condition_in_parens {
        // $$ = $1 && $4;
        $$ = katana_new_supports_exp(parser, KatanaSupportsOperatorAnd);
        katana_supports_exp_list_add(parser, $1, $$->exps);
        katana_supports_exp_list_add(parser, $4, $$->exps);
    }
    | supports_conjunction KATANA_CSS_SUPPORTS_AND maybe_space supports_condition_in_parens {
        // $$ = $1 && $4;
        $$ = katana_new_supports_exp(parser, KatanaSupportsOperatorAnd);
        katana_supports_exp_list_add(parser, $1, $$->exps);
        katana_supports_exp_list_add(parser, $4, $$->exps);
    }
    ;

supports_disjunction:
    supports_condition_in_parens KATANA_CSS_SUPPORTS_OR maybe_space supports_condition_in_parens {
        // $$ = $1 || $4;
        $$ = katana_new_supports_exp(parser, KatanaSupportsOperatorOr);
        katana_supports_exp_list_add(parser, $1, $$->exps);
        katana_supports_exp_list_add(parser, $4, $$->exps);
    }
    | supports_disjunction KATANA_CSS_SUPPORTS_OR maybe_space supports_condition_in_parens {
        // $$ = $1 || $4;
        $$ = katana_new_supports_exp(parser, KatanaSupportsOperatorOr);
        katana_supports_exp_list_add(parser, $1, $$->exps);
        katana_supports_exp_list_add(parser, $4, $$->exps);
    }
    ;

supports_condition_in_parens:
    '(' maybe_space supports_condition closing_parenthesis maybe_space {
        // $$ = $3;
        $$ = katana_new_supports_exp(parser, KatanaSupportsOperatorNone);
        katana_supports_exp_list_add(parser, $3, $$->exps);
    }
    | supports_declaration_condition
    | '(' error error_location error_recovery closing_parenthesis maybe_space {
        // parser->reportError($3, InvalidSupportsConditionCSSError);
        // $$ = false;
        $$ = 0;
    }
    ;

supports_declaration_condition:
    '(' maybe_space KATANA_CSS_IDENT maybe_space ':' maybe_space expr prio closing_parenthesis maybe_space {
        // $$ = false;
        // CSSPropertyID id = cssPropertyID($3);
        // if (id != CSSPropertyInvalid) {
        //    parser->m_valueList = parser->sinkFloatingValueList($7);
        //    int oldParsedProperties = parser->m_parsedProperties.size();
        //    $$ = parser->parseValue(id, $8);
        //    // We just need to know if the declaration is supported as it is written. Rollback any additions.
        //    if ($$)
        //        parser->rollbackLastProperties(parser->m_parsedProperties.size() - oldParsedProperties);
        // }
        // parser->m_valueList = nullptr;
        // parser->endProperty($8, false);
        //$$ = 0;
        $$ = katana_new_supports_exp(parser, KatanaSupportsOperatorNone);

        $$->decl = katana_parser_allocate(parser, sizeof(KatanaDeclaration));

        $$->decl->property = katana_string_to_characters(parser, &$3);
        $$->decl->values = $7;
        $$->decl->important = false;
    }
    | '(' maybe_space KATANA_CSS_IDENT maybe_space ':' maybe_space error error_recovery closing_parenthesis maybe_space {
        // $$ = false;
        // parser->endProperty(false, false, GeneralCSSError);        
        $$ = 0;
    }
    ;

before_keyframes_rule:
    /* empty */ {
      katana_start_rule_header(parser, KatanaRuleKeyframes);
    }
    ;

keyframes_rule_start:
    before_keyframes_rule KATANA_CSS_KEYFRAMES_SYM maybe_space
    {
      $$ = false;
    }
    ;

webkit_keyframes_rule_start:
    before_keyframes_rule KATANA_CSS_WEBKIT_KATANA_CSS_KEYFRAMES_SYM maybe_space
    ;

keyframes:
    keyframes_rule_start KATANA_CSS_IDENT at_rule_header_end_maybe_space
    '{' at_rule_body_start maybe_space location_label keyframes_rule closing_brace {
        $$ = katana_new_keyframes_rule(parser, &$2, $8, $1);
    }
    | webkit_keyframes_rule_start webkit_keyframe_name at_rule_header_end_maybe_space
    '{' at_rule_body_start maybe_space location_label keyframes_rule closing_brace {
        $$ = katana_new_keyframes_rule(parser, &$2, $8, true);
    }
    ;

webkit_keyframe_name:
    KATANA_CSS_IDENT
    | KATANA_CSS_STRING {
        // if (parser->m_context.useCounter())
        //    parser->m_context.useCounter()->count(UseCounter::QuotedKeyframesRule);
    }
    ;

keyframes_rule:
    keyframe_rule_list
    | keyframe_rule_list keyframes_error_recovery {
        katana_parser_clear_declarations(parser);
        katana_parser_reset_declarations(parser);
    };

keyframe_rule_list:
    /* empty */ {
        $$ = katana_new_Keyframe_list(parser);
        katana_parser_resume_error_logging();
    }
    |  keyframe_rule_list keyframe_rule maybe_space location_label {
        $$ = $1;
        katana_keyframe_rule_list_add(parser, $2, $$);
    }
    | keyframe_rule_list keyframes_error_recovery invalid_block maybe_space location_label {
        katana_parser_clear_declarations(parser);
        katana_parser_reset_declarations(parser);
        katana_parser_resume_error_logging();
    }
    ;

keyframe_rule:
    key_list '{' maybe_space declaration_list closing_brace {
        $$ = katana_new_keyframe(parser, $1);
    }
    ;

key_list:
    key maybe_space {
        $$ = katana_new_value_list(parser);
        katana_value_list_add(parser, $1, $$);
    }
    | key_list ',' maybe_space key maybe_space {
        $$ = $1;
        katana_value_list_add(parser, $4, $$);
    }
    ;

key:
    maybe_unary_operator KATANA_CSS_PERCENTAGE {
        (yyval.value) = katana_new_number_value(parser, $1, &$2, KATANA_VALUE_NUMBER);
    }
    | KATANA_CSS_IDENT {
        if (!strcasecmp($1.data, "from")) {
            KatanaParserNumber number;
            number.val = 0;
            number.raw = (KatanaParserString){"from", 4};
            $$ = katana_new_number_value(parser, 1, &number, KATANA_VALUE_NUMBER);
        }
        else if (!strcasecmp($1.data, "to")) {
            KatanaParserNumber number;
            number.val = 100;
            number.raw = (KatanaParserString){"to", 4};
            $$ = katana_new_number_value(parser, 1, &number, KATANA_VALUE_NUMBER);
        }
        else {
            YYERROR;
        }
    }
    ;

keyframes_error_recovery:
    error rule_error_recovery {
        // katana_parser_report_error(parser, parser->lastLocationLabel(), InvalidKeyframeSelectorCSSError);
        katana_parser_clear_declarations(parser);
        katana_parser_reset_declarations(parser);
        katana_parser_report_error(parser, NULL, "InvalidKeyframeSelectorCSSError");
    }
    ;

before_page_rule:
    /* empty */ {
      katana_start_rule_header(parser, KatanaRulePage);
        // parser->startRuleHeader(StyleRule::Page);
    }
    ;

page:
    before_page_rule KATANA_CSS_PAGE_SYM maybe_space page_selector at_rule_header_end
    '{' at_rule_body_start maybe_space_before_declaration declarations_and_margins closing_brace {
        $$ = katana_new_page_rule(parser);
        // if ($4)
        //     $$ = parser->createPageRule(parser->sinkFloatingSelector($4));
        // else {
        //    // Clear properties in the invalid @page rule.
        //    parser->clearProperties();
        //    // Also clear margin at-rules here once we fully implement margin at-rules parsing.
        //    $$ = 0;
        // }
    }
    ;

page_selector:
    KATANA_CSS_IDENT maybe_space {
        $$ = katana_new_selector(parser);
        $$->match = KatanaSelectorMatchTag;
        $$->tag = katana_new_qualified_name(parser, NULL, &$1, &parser->default_namespace);

        // $$ = parser->createFloatingSelectorWithTagName(QualifiedName(nullAtom, $1, parser->m_defaultNamespace));
        // $$->setForPage();
    }
    | KATANA_CSS_IDENT pseudo_page maybe_space {
        // $$ = $2;
        // $$->prependTagSelector(QualifiedName(nullAtom, $1, parser->m_defaultNamespace));
        // $$->setForPage();
    }
    | pseudo_page maybe_space {
        // $$ = $1;
        // $$->setForPage();
    }
    | /* empty */ {
        // $$ = parser->createFloatingSelector();
        // $$->setForPage();
    }
    ;

declarations_and_margins:
    declaration_list
    | declarations_and_margins margin_box maybe_space declaration_list
    ;

margin_box:
    margin_sym {
        // parser->startDeclarationsForMarginBox();
    } maybe_space '{' maybe_space declaration_list closing_brace {
        // $$ = parser->createMarginAtRule($1);
    }
    ;

margin_sym :
    TOPLEFTCORNER_SYM {
        // $$ = CSSSelector::TopLeftCornerMarginBox;
    }
    | TOPLEFT_SYM {
        // $$ = CSSSelector::TopLeftMarginBox;
    }
    | TOPCENTER_SYM {
        // $$ = CSSSelector::TopCenterMarginBox;
    }
    | TOPRIGHT_SYM {
        // $$ = CSSSelector::TopRightMarginBox;
    }
    | TOPRIGHTCORNER_SYM {
        // $$ = CSSSelector::TopRightCornerMarginBox;
    }
    | BOTTOMLEFTCORNER_SYM {
        // $$ = CSSSelector::BottomLeftCornerMarginBox;
    }
    | BOTTOMLEFT_SYM {
        // $$ = CSSSelector::BottomLeftMarginBox;
    }
    | BOTTOMCENTER_SYM {
        // $$ = CSSSelector::BottomCenterMarginBox;
    }
    | BOTTOMRIGHT_SYM {
        // $$ = CSSSelector::BottomRightMarginBox;
    }
    | BOTTOMRIGHTCORNER_SYM {
        // $$ = CSSSelector::BottomRightCornerMarginBox;
    }
    | LEFTTOP_SYM {
        // $$ = CSSSelector::LeftTopMarginBox;
    }
    | LEFTMIDDLE_SYM {
        // $$ = CSSSelector::LeftMiddleMarginBox;
    }
    | LEFTBOTTOM_SYM {
        // $$ = CSSSelector::LeftBottomMarginBox;
    }
    | RIGHTTOP_SYM {
        // $$ = CSSSelector::RightTopMarginBox;
    }
    | RIGHTMIDDLE_SYM {
        // $$ = CSSSelector::RightMiddleMarginBox;
    }
    | RIGHTBOTTOM_SYM {
        // $$ = CSSSelector::RightBottomMarginBox;
    }
    ;

before_font_face_rule:
    /* empty */ {
        katana_start_rule_header(parser, KatanaRuleFontFace);
    }
    ;

font_face:
    before_font_face_rule KATANA_CSS_FONT_FACE_SYM at_rule_header_end_maybe_space
    '{' at_rule_body_start maybe_space_before_declaration declaration_list closing_brace {
        $$ = katana_new_font_face(parser);
    }
    ;

before_viewport_rule:
    /* empty */ {
        // parser->markViewportRuleBodyStart();
        // parser->startRuleHeader(StyleRule::Viewport);
    }
    ;

viewport:
    before_viewport_rule KATANA_CSS_VIEWPORT_RULE_SYM at_rule_header_end_maybe_space
    '{' at_rule_body_start maybe_space_before_declaration declaration_list closing_brace {
        // $$ = parser->createViewportRule();
        // parser->markViewportRuleBodyEnd();
    }
;

combinator:
    '+' maybe_space { $$ = KatanaSelectorRelationDirectAdjacent; }
    | '~' maybe_space { $$ = KatanaSelectorRelationIndirectAdjacent; }
    | '>' maybe_space { $$ = KatanaSelectorRelationChild; }
    | '/' KATANA_CSS_IDENT '/' maybe_space {
        if (!strcasecmp($2.data, "deep"))
            $$ = KatanaSelectorRelationShadowDeep;
        else
            YYERROR;
    }
    ;

maybe_unary_operator:
    unary_operator
    | /* empty */ { $$ = 1; }
    ;

unary_operator:
    '-' { $$ = -1; }
  | '+' { $$ = 1; }
  ;

maybe_space_before_declaration:
    maybe_space {
        katana_start_declaration(parser);
    }
  ;

before_selector_list:
    /* empty */ {
        katana_start_rule_header(parser, KatanaRuleStyle);
        katana_start_selector(parser);
    }
  ;

at_rule_header_end:
    /* empty */ {
        katana_end_rule_header(parser);
    }
  ;

at_selector_end:
    /* empty */ {
        katana_end_selector(parser);
    }
  ;

ruleset:
    before_selector_list selector_list at_selector_end at_rule_header_end '{' at_rule_body_start maybe_space_before_declaration declaration_list closing_brace {
        $$ = katana_new_style_rule(parser, $2);
    }
  ;

before_selector_group_item:
    /* empty */ {
        katana_start_selector(parser);
    }

selector_list:
    selector %prec UNIMPORTANT_TOK {
        $$ = katana_reusable_selector_list(parser);
        katana_selector_list_shink(parser, 0, $$);
        katana_selector_list_add(parser, katana_sink_floating_selector(parser, $1), $$);
    }
    | selector_list at_selector_end ',' maybe_space before_selector_group_item selector %prec UNIMPORTANT_TOK {
        $$ = $1;
        katana_selector_list_add(parser, katana_sink_floating_selector(parser, $6), $$);
    }
   ;

selector:
    simple_selector
    | selector KATANA_CSS_WHITESPACE
    | selector KATANA_CSS_WHITESPACE simple_selector
    {
        $$ = $3;        
        KatanaSelector * end = $$;
        if ( NULL != end ) {
            while (NULL != end->tagHistory)
                end = end->tagHistory;
            end->relation = KatanaSelectorRelationDescendant;
            // if ($1->isContentPseudoElement())
            //     end->setRelationIsAffectedByPseudoContent();
            end->tagHistory = katana_sink_floating_selector(parser, $1);
        }
    }
    | selector combinator simple_selector {
        $$ = $3;
        KatanaSelector * end = $$;
        if ( NULL != end ) {
            while (NULL != end->tagHistory)
                end = end->tagHistory;
            end->relation = (yyvsp[-1].relation);
            // if ($1->isContentPseudoElement())
            //     end->setRelationIsAffectedByPseudoContent();
            end->tagHistory = katana_sink_floating_selector(parser, $1);
        }
    }
    ;

namespace_selector:
    /* empty */ '|' 
    { 
      katana_string_clear(parser,&$$); 
    }
    | '*' '|' 
    { 
      $$ = kKatanaAsteriskString; 
    }
    | KATANA_CSS_IDENT '|'
    {
      // namespace
      // printf("NS 1:%s\n",katana_string_to_characters(parser,&$1));
      // $$ = $1;
    }
    ;

simple_selector:
    element_name {
        $$ = katana_new_selector(parser);
        $$->match = KatanaSelectorMatchTag;
        $$->tag = katana_new_qualified_name(parser, NULL, &$1, &parser->default_namespace);
    }
    | element_name specifier_list {
        $$ = katana_rewrite_specifier_with_element_name(parser, &$1, $2);
        if (!$$)
            YYERROR;
    }
    | specifier_list {
        $$ = katana_rewrite_specifier_with_namespace_if_needed(parser, $1);
        if (!$$)
            YYERROR;
    }
    | namespace_selector element_name {
        $$ = katana_new_selector(parser);
        $$->match = KatanaSelectorMatchTag;
        $$->tag = katana_new_qualified_name(parser, &$1, &$2, &$1);
        // $$ = parser->createFloatingSelectorWithTagName(parser->determineNameInNamespace($1, $2));
        // if (!$$)
        //    YYERROR;
    }
    | namespace_selector element_name specifier_list {
        // printf("namespace_selector element_name specifier_list\n");
        // $$ = parser->rewriteSpecifiersWithElementName($1, $2, $3);
        // if (!$$)
        //    YYERROR;
    }
    | namespace_selector specifier_list {
        // printf("namespace_selector specifier_list\n");
        // $$ = parser->rewriteSpecifiersWithElementName($1, starAtom, $2);
        // if (!$$)
        //    YYERROR;
    }
  ;

simple_selector_list:
    simple_selector %prec UNIMPORTANT_TOK {
        // $$ = parser->createFloatingSelectorVector();
        // $$->append(parser->sinkFloatingSelector($1));
    }
    | simple_selector_list maybe_space ',' maybe_space simple_selector %prec UNIMPORTANT_TOK {
        // $$ = $1;
        // $$->append(parser->sinkFloatingSelector($5));
    }
  ;

element_name:
    KATANA_CSS_IDENT {
        // FIXME: 标签名是否区分大写
        // if (parser->m_context.isHTMLDocument())
        //     parser->tokenToLowerCase($1);
        $$ = $1;
    }
    | '*' {
        $$ = kKatanaAsteriskString;
    }
  ;

specifier_list:
    specifier
    | specifier_list specifier {
        $$ = katana_rewrite_specifiers(parser, $1, $2);
    }
;

specifier:
    KATANA_CSS_IDSEL {
        $$ = katana_new_selector(parser);
        $$->match =KatanaSelectorMatchId;
        // if (isQuirksModeBehavior(parser->m_context.mode()))
            // parser->tokenToLowerCase($1);
        katana_selector_set_value(parser, $$, &$1);
    }
  | KATANA_CSS_HEX {
        if ($1.data[0] >= '0' && $1.data[0] <= '9') {
            YYERROR;
        } else {
            $$ = katana_new_selector(parser);
            $$->match =KatanaSelectorMatchId;
            // if (isQuirksModeBehavior(parser->m_context.mode()))
                // parser->tokenToLowerCase($1);
            katana_selector_set_value(parser, $$, &$1);
        }
    }
  | class
  | attrib
  | pseudo
    ;

class:
    '.' KATANA_CSS_IDENT {
        $$ = katana_new_selector(parser);
        $$->match = KatanaSelectorMatchClass;
        // if (isQuirksModeBehavior(parser->m_context.mode()))
        //     parser->tokenToLowerCase($2);
        katana_selector_set_value(parser, $$, &$2);
    }
  ;

attr_name:
    KATANA_CSS_IDENT maybe_space {
        // if (parser->m_context.isHTMLDocument())
        //    parser->tokenToLowerCase($1);
        $$ = $1;
    }
    ;

attr_match_type:
    KATANA_CSS_IDENT maybe_space {
        KatanaAttributeMatchType attrMatchType = KatanaAttributeMatchTypeCaseSensitive;
        if (!katana_parse_attribute_match_type(parser, attrMatchType, &$1))
            YYERROR;
        $$ = attrMatchType;
    }
    ;

maybe_attr_match_type:
    attr_match_type
    | /* empty */ { $$ = KatanaAttributeMatchTypeCaseSensitive; }
    ;

attrib:
    '[' maybe_space attr_name closing_square_bracket {
        $$ = katana_new_selector(parser);
        $$->data->attribute = katana_new_qualified_name(parser, NULL, &$3, NULL);
        $$->data->bits.attributeMatchType = KatanaAttributeMatchTypeCaseSensitive;
        $$->match = KatanaSelectorMatchAttributeSet;
    }
    | '[' maybe_space attr_name match maybe_space ident_or_string maybe_space maybe_attr_match_type closing_square_bracket {
        $$ = katana_new_selector(parser);
        $$->data->attribute = katana_new_qualified_name(parser, NULL, &$3, NULL);
        $$->data->bits.attributeMatchType = $8;
        $$->match = $4;
        katana_selector_set_value(parser, $$, &$6);
    }
    | '[' maybe_space namespace_selector attr_name closing_square_bracket {
        $$ = katana_new_selector(parser);
        $$->data->attribute = katana_new_qualified_name(parser, &$3, &$4, NULL);
        $$->data->bits.attributeMatchType = KatanaAttributeMatchTypeCaseSensitive;
        $$->match = KatanaSelectorMatchAttributeSet;
    }
    | '[' maybe_space namespace_selector attr_name match maybe_space ident_or_string maybe_space maybe_attr_match_type closing_square_bracket {
        $$ = katana_new_selector(parser);
        $$->data->attribute = katana_new_qualified_name(parser, &$3, &$4, NULL);
        $$->data->bits.attributeMatchType = $9;
        $$->match = $5;
        katana_selector_set_value(parser, $$, &$7);
    }
    | '[' selector_recovery closing_square_bracket {
        YYERROR;
    }
  ;

match:
    '=' {
        $$ = KatanaSelectorMatchAttributeExact;
    }
    | KATANA_CSS_INCLUDES {
        $$ = KatanaSelectorMatchAttributeList;
    }
    | KATANA_CSS_DASHMATCH {
        $$ = KatanaSelectorMatchAttributeHyphen;
    }
    | KATANA_CSS_BEGINSWITH {
        $$ = KatanaSelectorMatchAttributeBegin;
    }
    | KATANA_CSS_ENDSWITH {
        $$ = KatanaSelectorMatchAttributeEnd;
    }
    | KATANA_CSS_CONTAINS {
        $$ = KatanaSelectorMatchAttributeContain;
    }
    ;

ident_or_string:
    KATANA_CSS_IDENT
  | KATANA_CSS_STRING
    ;

pseudo_page:
    ':' KATANA_CSS_IDENT {
      //  if ($2.isFunction())
      //      YYERROR;
      //  $$ = parser->createFloatingSelector();
      //  $$->setMatch(CSSSelector::PagePseudoClass);
      //  parser->tokenToLowerCase($2);
      //  $$->setValue($2);
      //  CSSSelector::PseudoType type = $$->pseudoType();
      //  if (type == CSSSelector::PseudoUnknown)
      //      YYERROR;
    }

pseudo:
    ':' error_location KATANA_CSS_IDENT {

        if (katana_string_is_function(&$3))
            YYERROR;
        $$ = katana_new_selector(parser);
        $$->match = KatanaSelectorMatchPseudoClass;
        katana_string_to_lowercase(parser, &$3);
        katana_selector_set_value(parser, $$, &$3);
        katana_selector_extract_pseudo_type($$);
        // if ($$->pseudo == KatanaSelectorPseudoUnknown) {
        //     katana_parser_report_error(parser, $2, InvalidSelectorPseudoCSSError);
        //     YYERROR;
    }
    | ':' ':' error_location KATANA_CSS_IDENT {
        if (katana_string_is_function(&$4))
            YYERROR;
        $$ = katana_new_selector(parser);
        $$->match = KatanaSelectorMatchPseudoElement;
        katana_string_to_lowercase(parser, &$4);
        katana_selector_set_value(parser, (yyval.selector), &$4);
        katana_selector_extract_pseudo_type((yyval.selector));
        // FIXME: This call is needed to force selector to compute the pseudoType early enough.
        // CSSSelector::PseudoType type = $$->pseudoType();
        // if (type == CSSSelector::PseudoUnknown) {
        //     katana_parser_report_error(parser, $3, InvalidSelectorPseudoCSSError);
        //     YYERROR;
    }
    // used by ::cue(:past/:future)
    | ':' ':' KATANA_CSS_CUEFUNCTION maybe_space simple_selector_list maybe_space closing_parenthesis {
        // $$ = parser->createFloatingSelector();
        // $$->setMatch(CSSSelector::PseudoElement);
        // $$->adoptSelectorVector(*parser->sinkFloatingSelectorVector($5));
        // $$->setValue($3);
        // CSSSelector::PseudoType type = $$->pseudoType();
        // if (type != CSSSelector::PseudoCue)
        //    YYERROR;
    }
    | ':' ':' KATANA_CSS_CUEFUNCTION selector_recovery closing_parenthesis {
        YYERROR;
    }
    // use by :-webkit-any.
    // FIXME: should we support generic selectors here or just simple_selectors?
    // Use simple_selector_list for now to match -moz-any.
    // See http://lists.w3.org/Archives/Public/www-style/2010Sep/0566.html for some
    // related discussion with respect to :not.
    | ':' KATANA_CSS_ANYFUNCTION maybe_space simple_selector_list maybe_space closing_parenthesis {
        // $$ = parser->createFloatingSelector();
        // $$->setMatch(CSSSelector::PseudoClass);
        // $$->adoptSelectorVector(*parser->sinkFloatingSelectorVector($4));
        // parser->tokenToLowerCase($2);
        // $$->setValue($2);
        // CSSSelector::PseudoType type = $$->pseudoType();
        // if (type != CSSSelector::PseudoAny)
        //    YYERROR;
    }
    | ':' KATANA_CSS_ANYFUNCTION selector_recovery closing_parenthesis {
        YYERROR;
    }
    // used by :nth-*(ax+b)
    | ':' KATANA_CSS_FUNCTION maybe_space KATANA_CSS_NTH maybe_space closing_parenthesis {
        $$ = katana_new_selector(parser);
        $$->match = KatanaSelectorMatchPseudoClass;
        katana_selector_set_argument(parser, $$, &$4);
        katana_selector_set_value(parser, (yyval.selector), &$2);
        katana_selector_extract_pseudo_type($$);
        // CSSSelector::PseudoType type = $$->pseudoType();
        // if (type == CSSSelector::PseudoUnknown)
        //     YYERROR;
    }
    // used by :nth-*
    | ':' KATANA_CSS_FUNCTION maybe_space maybe_unary_operator KATANA_CSS_INTEGER maybe_space closing_parenthesis {
        $$ = katana_new_selector(parser);
        $$->match = KatanaSelectorMatchPseudoClass;
        katana_selector_set_argument_with_number(parser, $$, $4, &$5);
        katana_selector_set_value(parser, (yyval.selector), &$2);
        katana_selector_extract_pseudo_type((yyval.selector));
        // $$ = parser->createFloatingSelector();
        // $$->setMatch(CSSSelector::PseudoClass);
        // $$->setArgument(AtomicString::number($4 * $5));
        // $$->setValue($2);
        // CSSSelector::PseudoType type = $$->pseudoType();
        // if (type == CSSSelector::PseudoUnknown)
        //    YYERROR;
    }
    // used by :nth-*(odd/even) and :lang
    | ':' KATANA_CSS_FUNCTION maybe_space KATANA_CSS_IDENT maybe_space closing_parenthesis {
        $$ = katana_new_selector(parser);
        $$->match = KatanaSelectorMatchPseudoClass;
        katana_selector_set_argument(parser, $$, &$4);
        
        katana_string_to_lowercase(parser, &$2);
        katana_selector_set_value(parser, $$, &$2);
        katana_selector_extract_pseudo_type((yyval.selector));
        // CSSSelector::PseudoType type = $$->pseudoType();
        // if (type == CSSSelector::PseudoUnknown)
        //    YYERROR;
        // else if (type == CSSSelector::PseudoNthChild ||
        //         type == CSSSelector::PseudoNthOfType ||
        //         type == CSSSelector::PseudoNthLastChild ||
        //         type == CSSSelector::PseudoNthLastOfType) {
        //    if (!isValidNthToken($4))
        //        YYERROR;
        // }
    }
    | ':' KATANA_CSS_FUNCTION selector_recovery closing_parenthesis {
        YYERROR;
    }
    // used by :not
    | ':' KATANA_CSS_NOTFUNCTION maybe_space simple_selector maybe_space closing_parenthesis {
        if (!katana_selector_is_simple(parser, $4))
            YYERROR;
        else {
            $$ = katana_new_selector(parser);
            $$->match = KatanaSelectorMatchPseudoClass;
            $$->pseudo = KatanaPseudoNot;

            KatanaArray* array = katana_new_array(parser);
            katana_selector_list_add(parser, katana_sink_floating_selector(parser, $4), array);
            katana_adopt_selector_list(parser, array, (yyval.selector));

            katana_string_to_lowercase(parser, &$2);
            katana_selector_set_value(parser, (yyval.selector), &$2);

        }
    }
    | ':' KATANA_CSS_NOTFUNCTION selector_recovery closing_parenthesis {
        YYERROR;
    }
    | ':' KATANA_CSS_HOSTFUNCTION maybe_space simple_selector_list maybe_space closing_parenthesis {
        // $$ = parser->createFloatingSelector();
        // $$->setMatch(CSSSelector::PseudoClass);
        // $$->adoptSelectorVector(*parser->sinkFloatingSelectorVector($4));
        // parser->tokenToLowerCase($2);
        // $$->setValue($2);
        // CSSSelector::PseudoType type = $$->pseudoType();
        // if (type != CSSSelector::PseudoHost)
        //    YYERROR;
        YYERROR;
    }
    | ':' KATANA_CSS_HOSTFUNCTION selector_recovery closing_parenthesis {
        YYERROR;
    }
    //  used by :host-context()
    | ':' KATANA_CSS_HOSTCONTEXTFUNCTION maybe_space simple_selector_list maybe_space closing_parenthesis {
        // $$ = parser->createFloatingSelector();
        // $$->setMatch(CSSSelector::PseudoClass);
        // $$->adoptSelectorVector(*parser->sinkFloatingSelectorVector($4));
        // parser->tokenToLowerCase($2);
        // $$->setValue($2);
        // CSSSelector::PseudoType type = $$->pseudoType();
        //if (type != CSSSelector::PseudoHostContext)
        //    YYERROR;
        YYERROR;
    }
    | ':' KATANA_CSS_HOSTCONTEXTFUNCTION selector_recovery closing_parenthesis {
        YYERROR;
    }
  ;

selector_recovery:
    error error_location error_recovery;

declaration_list:
    /* empty */ { $$ = false; }
    | declaration
    | decl_list declaration {
        $$ = $1 || $2;
    }
    | decl_list
    ;

decl_list:
    declaration ';' maybe_space {
        katana_start_declaration(parser);
        $$ = $1;
    }
    | decl_list declaration ';' maybe_space {
        katana_start_declaration(parser);
        $$ = $1 || $2;
    }
    ;

declaration:
    property ':' maybe_space error_location expr prio {
        $$ = false;
        bool isPropertyParsed = false;
        // unsigned int oldParsedProperties = parser->parsedProperties->length;
        (yyval.boolean) = katana_new_declaration(parser, &$1, $6, $5);
        if (!(yyval.boolean)) {
            // parser->rollbackLastProperties(parser->m_parsedProperties.size() - oldParsedProperties);
            katana_parser_report_error(parser, $4, "InvalidPropertyValueCSSError");
        } else {
            isPropertyParsed = true;
        }
        katana_end_declaration(parser, $6, isPropertyParsed);
    }
    |
    property ':' maybe_space error_location expr prio error error_recovery {
        /* When we encounter something like p {color: red !important fail;} we should drop the declaration */
        katana_parser_report_error(parser, $4, "InvalidPropertyValueCSSError");
        katana_end_declaration(parser, false, false);
        $$ = false;
    }
    |
    property ':' maybe_space error_location error error_recovery {
        katana_parser_report_error(parser, $4, "InvalidPropertyValueCSSError");
        katana_end_declaration(parser, false, false);
        $$ = false;
    }
    |
    property error error_location error_recovery {
        katana_parser_report_error(parser, $3, "PropertyDeclarationCSSError");
        katana_end_declaration(parser, false, false);
        $$ = false;
    }
    |
    error error_location error_recovery {
        katana_parser_report_error(parser, $2, "PropertyDeclarationCSSError");
        $$ = false;
    }
  ;

property:
    error_location KATANA_CSS_IDENT maybe_space {
        // $$ = cssPropertyID($2);
        // parser->setCurrentProperty($$);
        // if ($$ == CSSPropertyInvalid)
        //    parser->reportError($1, InvalidPropertyCSSError);
        // $$ = $2;
        // katana_set_current_declaration(parser, &$$);

        $$ = $2;
        katana_set_current_declaration(parser, &$$);
    }
  ;

prio:
    KATANA_CSS_IMPORTANT_SYM maybe_space { $$ = true; }
    | /* empty */ { $$ = false; }
  ;

ident_list:
    KATANA_CSS_IDENT maybe_space {
        $$ = katana_new_value_list(parser);
        katana_value_list_add(parser, katana_new_ident_value(parser, &$1), $$);

    }
    | ident_list KATANA_CSS_IDENT maybe_space {
        $$ = $1;
        katana_value_list_add(parser, katana_new_ident_value(parser, &$2), (yyval.valueList));
    }
    ;

track_names_list:
    '(' maybe_space closing_parenthesis {
        $$ = katana_new_list_value(parser, NULL);
    }
    | '(' maybe_space ident_list closing_parenthesis {
        $$ = katana_new_list_value(parser, $3);
    }
    | '(' maybe_space expr_recovery closing_parenthesis {
        YYERROR;
    }
  ;

expr:
    term {
        $$ = katana_new_value_list(parser);
        katana_value_list_add(parser, $1, $$);
    }
    | expr operator term {
        $$ = $1;
        katana_value_list_add(parser, katana_new_operator_value(parser, $2), $$);
        katana_value_list_add(parser, $3, $$); 
    }
    | expr term {
        $$ = $1;
        katana_value_list_add(parser, $2, $$);
    }
     | expr slash_operator slash_operator term {
         // $$ = $1;
         // $$->addValue(makeOperatorValue($2));
         // $$->addValue(makeOperatorValue($3));
         // $$->addValue(parser->sinkFloatingValue($4));
     }
  ;

expr_recovery:
    error error_location error_recovery {
        katana_parser_report_error(parser, $2, "PropertyDeclarationCSSError");
    }
  ;

slash_operator:
      '/' maybe_space {
          $$ = '/';
      }
   ;
 
operator:
    slash_operator
  | ',' maybe_space {
        $$ = ',';
    }
  ;

term:
  unary_term maybe_space
  | unary_operator unary_term maybe_space 
  { 
    $$ = $2; 
    // $$.fValue *= $1; 
    katana_value_set_sign(parser, $$, $1);
  }
  | KATANA_CSS_STRING maybe_space { $$ = katana_new_value(parser); $$->id = KatanaValueInvalid; $$->isInt = false; katana_value_set_string(parser, $$, &$1); $$->unit = KATANA_VALUE_STRING; }
  | KATANA_CSS_IDENT maybe_space { $$ = katana_new_ident_value(parser, &$1); }
  /* We might need to actually parse the number from a dimension, but we can't just put something that uses $$.string into unary_term. */
  | KATANA_CSS_DIMEN maybe_space { $$ = katana_new_value(parser); $$->id = KatanaValueInvalid; katana_value_set_string(parser, $$, &$1); $$->isInt = false; $$->unit = KATANA_VALUE_DIMENSION; }
  | unary_operator KATANA_CSS_DIMEN maybe_space { $$ = katana_new_value(parser); $$->id = KatanaValueInvalid; katana_value_set_string(parser, $$, &$2); $$->isInt = false; $$->unit = KATANA_VALUE_DIMENSION; }
  | KATANA_CSS_URI maybe_space { $$ = katana_new_value(parser); $$->id = KatanaValueInvalid; katana_value_set_string(parser, $$, &$1); $$->isInt = false; $$->unit = KATANA_VALUE_URI; }
  | KATANA_CSS_UNICODERANGE maybe_space { $$ = katana_new_value(parser); $$->id = KatanaValueInvalid; katana_value_set_string(parser, $$, &$1); $$->isInt = false; $$->unit = KATANA_VALUE_UNICODE_RANGE; }
  | KATANA_CSS_HEX maybe_space { $$ = katana_new_value(parser); $$->id = KatanaValueInvalid; katana_value_set_string(parser, $$, &$1); $$->isInt = false; $$->unit = KATANA_VALUE_PARSER_HEXCOLOR; }
  | '#' maybe_space { $$ = katana_new_value(parser); $$->id = KatanaValueInvalid; 
    KatanaParserString tmp = {"#", 1}; 
    katana_value_set_string(parser, $$, &tmp); 
    $$->isInt = false; $$->unit = KATANA_VALUE_PARSER_HEXCOLOR; } /* Handle error case: "color: #;" */
  /* FIXME: according to the specs a function can have a unary_operator in front. I know no case where this makes sense */
  | function maybe_space
  | calc_function maybe_space
  | '%' maybe_space { /* Handle width: %; */
      $$ = katana_new_value(parser); $$->id = KatanaValueInvalid; $$->isInt = false; $$->unit = 0;
  }
  | track_names_list maybe_space
  ;

unary_term:
  KATANA_CSS_INTEGER { $$ = katana_new_number_value(parser, 1, &$1, KATANA_VALUE_NUMBER); $$->isInt = true; }
  | KATANA_CSS_FLOATTOKEN { $$ = katana_new_number_value(parser, 1, &$1, KATANA_VALUE_NUMBER); }
  | KATANA_CSS_PERCENTAGE { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_PERCENTAGE); }
  | KATANA_CSS_PXS { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_PX); }
  | KATANA_CSS_CMS { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_CM); }
  | KATANA_CSS_MMS { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_MM); }
  | KATANA_CSS_INS { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_IN); }
  | KATANA_CSS_PTS { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_PT); }
  | KATANA_CSS_PCS { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_PC); }
  | KATANA_CSS_DEGS { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_DEG); }
  | KATANA_CSS_RADS { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_RAD); }
  | KATANA_CSS_GRADS { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_GRAD); }
  | KATANA_CSS_TURNS { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_TURN); }
  | KATANA_CSS_MSECS { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_MS); }
  | KATANA_CSS_SECS { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_S); }
  | KATANA_CSS_HERTZ { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_HZ); }
  | KATANA_CSS_KHERTZ { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_KHZ); }
  | KATANA_CSS_EMS { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_EMS); }
  | KATANA_CSS_QEMS { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_PARSER_Q_EMS); }
  | KATANA_CSS_EXS { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_EXS); }
  | KATANA_CSS_REMS {
      $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_REMS);
      /* if (parser->m_styleSheet)
          parser->m_styleSheet->parserSetUsesRemUnits(true); */
  }
  | KATANA_CSS_CHS { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_CHS); }
  | KATANA_CSS_VW { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_VW); }
  | KATANA_CSS_VH { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_VH); }
  | KATANA_CSS_VMIN { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_VMIN); }
  | KATANA_CSS_VMAX { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_VMAX); }
  | KATANA_CSS_DPPX { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_DPPX); }
  | KATANA_CSS_DPI { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_DPI); }
  | KATANA_CSS_DPCM { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_DPCM); }
  | KATANA_CSS_FR { $$ = katana_new_dimension_value(parser, &$1, KATANA_VALUE_FR); }
  ;

function:
    KATANA_CSS_FUNCTION maybe_space expr closing_parenthesis {
        $$ = katana_new_function_value(parser, &$1, $3);
    } |
    KATANA_CSS_FUNCTION maybe_space closing_parenthesis {
        $$ = katana_new_function_value(parser, &$1, NULL);
    } |
    KATANA_CSS_FUNCTION maybe_space expr_recovery closing_parenthesis {
        YYERROR;
    }
  ;

calc_func_term:
  unary_term
  | unary_operator unary_term { $$ = $2; $$->fValue *= $1; }
  ;

calc_func_operator:
    space '+' space {
        $$ = '+';
    }
    | space '-' space {
        $$ = '-';
    }
    | calc_maybe_space '*' maybe_space {
        $$ = '*';
    }
    | calc_maybe_space '/' maybe_space {
        $$ = '/';
    }
  ;

calc_maybe_space:
    /* empty */
    | KATANA_CSS_WHITESPACE
  ;

calc_func_paren_expr:
    '(' maybe_space calc_func_expr calc_maybe_space closing_parenthesis {
        $$ = $3;
        katana_value_list_insert(parser, katana_new_operator_value(parser, '('), 0, $$);
        katana_new_operator_value(parser, ')');
        katana_value_list_add(parser, katana_new_operator_value(parser, ')'), $$);
    }
    | '(' maybe_space expr_recovery closing_parenthesis {
        YYERROR;
    }
  ;

calc_func_expr:
    calc_func_term {
        $$ = katana_new_value_list(parser);
        katana_value_list_add(parser, $1, $$);
    }
    | calc_func_expr calc_func_operator calc_func_term {
        $$ = $1;
        katana_value_list_add(parser, katana_new_operator_value(parser, $2), $$);
        katana_value_list_add(parser, $3, $$);
    }
    | calc_func_expr calc_func_operator calc_func_paren_expr {
        $$ = $1;
        katana_value_list_add(parser, katana_new_operator_value(parser, $2), $$);
        katana_value_list_steal_values(parser, $3, $$);
    }
    | calc_func_paren_expr
  ;

calc_function:
    KATANA_CSS_CALCFUNCTION maybe_space calc_func_expr calc_maybe_space closing_parenthesis {
//        $$.setFromFunction(parser->createFloatingFunction($1, parser->sinkFloatingValueList($3)));
        $$ = katana_new_function_value(parser, &$1, $3);
    }
    | KATANA_CSS_CALCFUNCTION maybe_space expr_recovery closing_parenthesis {
        YYERROR;
    }
    ;


invalid_at:
    KATANA_CSS_ATKEYWORD
  | margin_sym
    ;

at_rule_recovery:
    at_rule_header_recovery at_invalid_rule_header_end at_rule_end
    ;

at_rule_header_recovery:
    error error_location rule_error_recovery {
        katana_parser_report_error(parser, $2, "InvalidRuleCSSError");
    }
    ;

at_rule_end:
    at_invalid_rule_header_end semi_or_eof
  | at_invalid_rule_header_end invalid_block
    ;

regular_invalid_at_rule_header:
    keyframes_rule_start at_rule_header_recovery
  | webkit_keyframes_rule_start at_rule_header_recovery
  | before_page_rule KATANA_CSS_PAGE_SYM at_rule_header_recovery
  | before_font_face_rule KATANA_CSS_FONT_FACE_SYM at_rule_header_recovery
  | before_supports_rule KATANA_CSS_SUPPORTS_SYM error error_location rule_error_recovery {
        // parser->reportError($4, InvalidSupportsConditionCSSError);
        // parser->popSupportsRuleData();
    }
  | before_viewport_rule KATANA_CSS_VIEWPORT_RULE_SYM at_rule_header_recovery {
        // parser->markViewportRuleBodyEnd();
    }
  | import_rule_start at_rule_header_recovery
  | KATANA_CSS_NAMESPACE_SYM at_rule_header_recovery
  | error_location invalid_at at_rule_header_recovery {
        // parser->resumeErrorLogging();
        // parser->reportError($1, InvalidRuleCSSError);
    }
  ;

invalid_rule:
    error error_location rule_error_recovery at_invalid_rule_header_end invalid_block {
        katana_parser_report_error(parser, $2, "InvalidRuleCSSError invalid_rule");
    }
  | regular_invalid_at_rule_header at_invalid_rule_header_end ';'
  | regular_invalid_at_rule_header at_invalid_rule_header_end invalid_block
  | media_rule_start maybe_media_list ';'
    ;

invalid_rule_header:
    error error_location rule_error_recovery at_invalid_rule_header_end {
        katana_parser_report_error(parser, $2, "InvalidRuleCSSError invalid_rule_header");
    }
  | regular_invalid_at_rule_header at_invalid_rule_header_end
  | media_rule_start maybe_media_list
    ;

at_invalid_rule_header_end:
   /* empty */ {
        katana_end_invalid_rule_header(parser);
   }
   ;

invalid_block:
    '{' error_recovery closing_brace {
        katana_parser_report_error(parser, parser->position, "invalidBlockHit");
    }
    ;

invalid_square_brackets_block:
    '[' error_recovery closing_square_bracket
    ;

invalid_parentheses_block:
    opening_parenthesis error_recovery closing_parenthesis;

opening_parenthesis:
    '(' | KATANA_CSS_FUNCTION | KATANA_CSS_CALCFUNCTION | KATANA_CSS_ANYFUNCTION | KATANA_CSS_NOTFUNCTION | KATANA_CSS_CUEFUNCTION | KATANA_CSS_DISTRIBUTEDFUNCTION | KATANA_CSS_HOSTFUNCTION
    ;

error_location: {
        $$ = katana_parser_current_location(parser, &yylloc);
    }
    ;

location_label: {
        // parser->setLocationLabel(parser->currentLocation());
    }
    ;

error_recovery:
    /* empty */
  | error_recovery error
  | error_recovery invalid_block
  | error_recovery invalid_square_brackets_block
  | error_recovery invalid_parentheses_block
    ;

rule_error_recovery:
    /* empty */
  | rule_error_recovery error
  | rule_error_recovery invalid_square_brackets_block
  | rule_error_recovery invalid_parentheses_block
    ;

%%
