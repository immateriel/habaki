%{
/* Substitute the type names.  */
#define YYSTYPE         KATANASTYPE
#define YYLTYPE         KATANALTYPE

#include "tokenizer.h"

extern int yylex \
            (YYSTYPE* yylval_param, YYLTYPE* yylloc_param, yyscan_t yyscanner, void* parser);

#define YY_DECL int yylex \
            (YYSTYPE * yylval_param, YYLTYPE* yylloc_param, yyscan_t yyscanner, void* parser)

#define KATANA_TOKEN(x) katana_tokenize(yylval, yylloc, yyscanner, parser, x); return (x);

#define YY_USER_INIT yylineno = yycolumn = yylloc->first_line = yylloc->last_line = yylloc->first_column = yylloc->last_column = 1;

#define YY_USER_ACTION \
        yylloc->first_line = yylloc->last_line = yylineno; \
        yylloc->first_column = yycolumn; yylloc->last_column = yycolumn+(int)yyleng-1; \
        yycolumn += (int)yyleng;
        
%}

%option noline
%option reentrant
%option prefix="katana"
%option bison-bridge
%option bison-locations
%option yylineno
%option noinput

%option case-insensitive
%option noyywrap
%option 8bit
%option stack
%s mediaquery
%s supports
%s forkeyword

h               [0-9a-fA-F]
nonascii        [\200-\377]
unicode         \\{h}{1,6}[ \t\r\n\f]?
escape          {unicode}|\\[ -~\200-\377]
nmstart         [_a-zA-Z]|{nonascii}|{escape}
nmchar          [_a-zA-Z0-9-]|{nonascii}|{escape}
string1         \"([\t !#$%&(-~]|\\{nl}|\'|{nonascii}|{escape})*\"
string2         \'([\t !#$%&(-~]|\\{nl}|\"|{nonascii}|{escape})*\'

ident           -?{nmstart}{nmchar}*
num             [0-9]+|[0-9]*"."[0-9]+
intnum          [0-9]+
string          {string1}|{string2}
url             ([!#$%&*-~]|{nonascii}|{escape})*
w               [ \t\r\n\f]*
nl              \n|\r\n|\r|\f
range           \?{1,6}|{h}(\?{0,5}|{h}(\?{0,4}|{h}(\?{0,3}|{h}(\?{0,2}|{h}(\??|{h})))))
nth             [\+-]?{intnum}*n([\t\r\n ]*[\+-][\t\r\n ]*{intnum})?

%%

\/\*[^*]*\*+([^/*][^*]*\*+)*\/ { /* ignore comments */ }

[ \t\r\n\f]+            {KATANA_TOKEN(KATANA_CSS_WHITESPACE)}

"<!--"                  {KATANA_TOKEN(KATANA_CSS_SGML_CD)}
"-->"                   {KATANA_TOKEN(KATANA_CSS_SGML_CD)}
"~="                    {KATANA_TOKEN(KATANA_CSS_INCLUDES)}
"|="                    {KATANA_TOKEN(KATANA_CSS_DASHMATCH)}
"^="                    {KATANA_TOKEN(KATANA_CSS_BEGINSWITH)}
"$="                    {KATANA_TOKEN(KATANA_CSS_ENDSWITH)}
"*="                    {KATANA_TOKEN(KATANA_CSS_CONTAINS)}
<mediaquery>"not"       {KATANA_TOKEN(KATANA_CSS_MEDIA_NOT)}
<mediaquery>"only"      {KATANA_TOKEN(KATANA_CSS_MEDIA_ONLY)}
<mediaquery>"and"       {KATANA_TOKEN(KATANA_CSS_MEDIA_AND)}
<supports>"not"         {KATANA_TOKEN(KATANA_CSS_SUPPORTS_NOT)}
<supports>"or"          {KATANA_TOKEN(KATANA_CSS_SUPPORTS_OR)}
<supports>"and"         {KATANA_TOKEN(KATANA_CSS_SUPPORTS_AND)}

{string}                {KATANA_TOKEN(KATANA_CSS_STRING)}
{ident}                 {KATANA_TOKEN(KATANA_CSS_IDENT)}
{nth}                   {KATANA_TOKEN(KATANA_CSS_NTH)}

"#"{h}+                 {KATANA_TOKEN(KATANA_CSS_HEX)}
"#"{ident}              {KATANA_TOKEN(KATANA_CSS_IDSEL)}

"@import"               {BEGIN(mediaquery); KATANA_TOKEN(KATANA_CSS_IMPORT_SYM)}
"@page"                 {KATANA_TOKEN(KATANA_CSS_PAGE_SYM)}
"@media"                {BEGIN(mediaquery); KATANA_TOKEN(KATANA_CSS_MEDIA_SYM)}
"@font-face"            {KATANA_TOKEN(KATANA_CSS_FONT_FACE_SYM)}
"@charset"              {KATANA_TOKEN(KATANA_CSS_CHARSET_SYM)}
"@namespace"            {BEGIN(mediaquery); KATANA_TOKEN(KATANA_CSS_NAMESPACE_SYM) }
"@keyframes"            {KATANA_TOKEN(KATANA_CSS_KEYFRAMES_SYM) }
"@supports"             {BEGIN(supports); KATANA_TOKEN(KATANA_CSS_SUPPORTS_SYM)}

"@-internal-rule"               {KATANA_TOKEN(KATANA_INTERNAL_RULE_SYM)}
"@-internal-keyframe-rule"      {KATANA_TOKEN(KATANA_INTERNAL_KEYFRAME_RULE_SYM)}
"@-internal-keyframe-key-list"  {KATANA_TOKEN(KATANA_INTERNAL_KEYFRAME_KEY_LIST_SYM)}
"@-internal-media-list"         {KATANA_TOKEN(KATANA_INTERNAL_MEDIALIST_SYM)}
"@-internal-value"              {KATANA_TOKEN(KATANA_INTERNAL_VALUE_SYM)}
"@-internal-selector"           {KATANA_TOKEN(KATANA_INTERNAL_SELECTOR_SYM)}
"@-internal-decls"              {KATANA_TOKEN(KATANA_INTERNAL_DECLS_SYM)}

"@"{ident}              {KATANA_TOKEN(KATANA_CSS_ATKEYWORD) }

"!"{w}"important"       {KATANA_TOKEN(KATANA_CSS_IMPORTANT_SYM)}

{num}em                 {KATANA_TOKEN(KATANA_CSS_EMS)}
{num}rem                {KATANA_TOKEN(KATANA_CSS_REMS)}
{num}ch                 {KATANA_TOKEN(KATANA_CSS_CHS)}
{num}__qem              {KATANA_TOKEN(KATANA_CSS_QEMS)} /* quirky ems */
{num}ex                 {KATANA_TOKEN(KATANA_CSS_EXS)}
{num}px                 {KATANA_TOKEN(KATANA_CSS_PXS)}
{num}cm                 {KATANA_TOKEN(KATANA_CSS_CMS)}
{num}mm                 {KATANA_TOKEN(KATANA_CSS_MMS)}
{num}in                 {KATANA_TOKEN(KATANA_CSS_INS)}
{num}pt                 {KATANA_TOKEN(KATANA_CSS_PTS)}
{num}pc                 {KATANA_TOKEN(KATANA_CSS_PCS)}
{num}deg                {KATANA_TOKEN(KATANA_CSS_DEGS)}
{num}rad                {KATANA_TOKEN(KATANA_CSS_RADS)}
{num}grad               {KATANA_TOKEN(KATANA_CSS_GRADS)}
{num}turn               {KATANA_TOKEN(KATANA_CSS_TURNS)}
{num}ms                 {KATANA_TOKEN(KATANA_CSS_MSECS)}
{num}s                  {KATANA_TOKEN(KATANA_CSS_SECS)}
{num}Hz                 {KATANA_TOKEN(KATANA_CSS_HERTZ)}
{num}kHz                {KATANA_TOKEN(KATANA_CSS_KHERTZ)}
{num}vw                 {KATANA_TOKEN(KATANA_CSS_VW)}
{num}vh                 {KATANA_TOKEN(KATANA_CSS_VH)}
{num}vmin               {KATANA_TOKEN(KATANA_CSS_VMIN)}
{num}vmax               {KATANA_TOKEN(KATANA_CSS_VMAX)}
{num}dppx               {KATANA_TOKEN(KATANA_CSS_DPPX)}
{num}dpi                {KATANA_TOKEN(KATANA_CSS_DPI)}
{num}dpcm               {KATANA_TOKEN(KATANA_CSS_DPCM)}
{num}fr                 {KATANA_TOKEN(KATANA_CSS_FR)}
{num}{ident}            {KATANA_TOKEN(KATANA_CSS_DIMEN)}
{num}{ident}\+          {KATANA_TOKEN(KATANA_CSS_INVALIDDIMEN)}
{num}%+                 {KATANA_TOKEN(KATANA_CSS_PERCENTAGE)}
{intnum}                {KATANA_TOKEN(KATANA_CSS_INTEGER)}
{num}                   {KATANA_TOKEN(KATANA_CSS_FLOATTOKEN)}

"-webkit-any("          {KATANA_TOKEN(KATANA_CSS_ANYFUNCTION)}
"not("                  {KATANA_TOKEN(KATANA_CSS_NOTFUNCTION)}
"cue("                  {KATANA_TOKEN(KATANA_CSS_CUEFUNCTION)}
"host("                 {KATANA_TOKEN(KATANA_CSS_HOSTFUNCTION)}
"url("{w}{string}{w}")" {KATANA_TOKEN(KATANA_CSS_URI)}
"url("{w}{url}{w}")"    {KATANA_TOKEN(KATANA_CSS_URI)}
"calc("                 {KATANA_TOKEN(KATANA_CSS_CALCFUNCTION)}
"min("                  {KATANA_TOKEN(KATANA_CSS_MINFUNCTION)}
"max("                  {KATANA_TOKEN(KATANA_CSS_MAXFUNCTION)}
{ident}"("              {KATANA_TOKEN(KATANA_CSS_FUNCTION)}

U\+{range}              {KATANA_TOKEN(KATANA_CSS_UNICODERANGE)}
U\+{h}{1,6}-{h}{1,6}    {KATANA_TOKEN(KATANA_CSS_UNICODERANGE)}

<mediaquery>"{"         |
<mediaquery>";"         {BEGIN(INITIAL); KATANA_TOKEN(*yytext) }
<supports>"{"           |
<supports>";"           {BEGIN(INITIAL); KATANA_TOKEN(*yytext) }
.                       {KATANA_TOKEN(*yytext)}

%%

