/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.5.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 2

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Substitute the type names.  */
#define YYSTYPE         KATANASTYPE
#define YYLTYPE         KATANALTYPE
/* Substitute the variable and function names.  */
#define yyparse         katanaparse
#define yylex           katanalex
#define yyerror         katanaerror
#define yydebug         katanadebug
#define yynerrs         katananerrs

/* First part of user prologue.  */

  #include "tokenizer.h"


# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
#ifndef YY_KATANA_SRC_KATANA_TAB_H_INCLUDED
# define YY_KATANA_SRC_KATANA_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef KATANADEBUG
# if defined YYDEBUG
#if YYDEBUG
#   define KATANADEBUG 1
#  else
#   define KATANADEBUG 0
#  endif
# else /* ! defined YYDEBUG */
#  define KATANADEBUG 0
# endif /* ! defined YYDEBUG */
#endif  /* ! defined KATANADEBUG */
#if KATANADEBUG
extern int katanadebug;
#endif
/* "%code requires" blocks.  */


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



/* Token type.  */
#ifndef KATANATOKENTYPE
# define KATANATOKENTYPE
  enum katanatokentype
  {
    TOKEN_EOF = 0,
    LOWEST_PREC = 258,
    UNIMPORTANT_TOK = 259,
    KATANA_CSS_WHITESPACE = 260,
    KATANA_CSS_SGML_CD = 261,
    KATANA_CSS_INCLUDES = 262,
    KATANA_CSS_DASHMATCH = 263,
    KATANA_CSS_BEGINSWITH = 264,
    KATANA_CSS_ENDSWITH = 265,
    KATANA_CSS_CONTAINS = 266,
    KATANA_CSS_STRING = 267,
    KATANA_CSS_IDENT = 268,
    KATANA_CSS_NTH = 269,
    KATANA_CSS_HEX = 270,
    KATANA_CSS_IDSEL = 271,
    KATANA_CSS_IMPORT_SYM = 272,
    KATANA_CSS_PAGE_SYM = 273,
    KATANA_CSS_MEDIA_SYM = 274,
    KATANA_CSS_SUPPORTS_SYM = 275,
    KATANA_CSS_FONT_FACE_SYM = 276,
    KATANA_CSS_CHARSET_SYM = 277,
    KATANA_CSS_NAMESPACE_SYM = 278,
    KATANA_CSS_VIEWPORT_RULE_SYM = 279,
    KATANA_INTERNAL_DECLS_SYM = 280,
    KATANA_INTERNAL_MEDIALIST_SYM = 281,
    KATANA_INTERNAL_RULE_SYM = 282,
    KATANA_INTERNAL_SELECTOR_SYM = 283,
    KATANA_INTERNAL_VALUE_SYM = 284,
    KATANA_INTERNAL_KEYFRAME_RULE_SYM = 285,
    KATANA_INTERNAL_KEYFRAME_KEY_LIST_SYM = 286,
    KATANA_INTERNAL_SUPPORTS_CONDITION_SYM = 287,
    KATANA_CSS_KEYFRAMES_SYM = 288,
    KATANA_CSS_WEBKIT_KATANA_CSS_KEYFRAMES_SYM = 289,
    TOPLEFTCORNER_SYM = 290,
    TOPLEFT_SYM = 291,
    TOPCENTER_SYM = 292,
    TOPRIGHT_SYM = 293,
    TOPRIGHTCORNER_SYM = 294,
    BOTTOMLEFTCORNER_SYM = 295,
    BOTTOMLEFT_SYM = 296,
    BOTTOMCENTER_SYM = 297,
    BOTTOMRIGHT_SYM = 298,
    BOTTOMRIGHTCORNER_SYM = 299,
    LEFTTOP_SYM = 300,
    LEFTMIDDLE_SYM = 301,
    LEFTBOTTOM_SYM = 302,
    RIGHTTOP_SYM = 303,
    RIGHTMIDDLE_SYM = 304,
    RIGHTBOTTOM_SYM = 305,
    KATANA_CSS_ATKEYWORD = 306,
    KATANA_CSS_IMPORTANT_SYM = 307,
    KATANA_CSS_MEDIA_ONLY = 308,
    KATANA_CSS_MEDIA_NOT = 309,
    KATANA_CSS_MEDIA_AND = 310,
    KATANA_CSS_MEDIA_OR = 311,
    KATANA_CSS_SUPPORTS_NOT = 312,
    KATANA_CSS_SUPPORTS_AND = 313,
    KATANA_CSS_SUPPORTS_OR = 314,
    KATANA_CSS_REMS = 315,
    KATANA_CSS_CHS = 316,
    KATANA_CSS_QEMS = 317,
    KATANA_CSS_EMS = 318,
    KATANA_CSS_EXS = 319,
    KATANA_CSS_PXS = 320,
    KATANA_CSS_CMS = 321,
    KATANA_CSS_MMS = 322,
    KATANA_CSS_INS = 323,
    KATANA_CSS_PTS = 324,
    KATANA_CSS_PCS = 325,
    KATANA_CSS_DEGS = 326,
    KATANA_CSS_RADS = 327,
    KATANA_CSS_GRADS = 328,
    KATANA_CSS_TURNS = 329,
    KATANA_CSS_MSECS = 330,
    KATANA_CSS_SECS = 331,
    KATANA_CSS_HERTZ = 332,
    KATANA_CSS_KHERTZ = 333,
    KATANA_CSS_DIMEN = 334,
    KATANA_CSS_INVALIDDIMEN = 335,
    KATANA_CSS_PERCENTAGE = 336,
    KATANA_CSS_FLOATTOKEN = 337,
    KATANA_CSS_INTEGER = 338,
    KATANA_CSS_VW = 339,
    KATANA_CSS_VH = 340,
    KATANA_CSS_VMIN = 341,
    KATANA_CSS_VMAX = 342,
    KATANA_CSS_DPPX = 343,
    KATANA_CSS_DPI = 344,
    KATANA_CSS_DPCM = 345,
    KATANA_CSS_FR = 346,
    KATANA_CSS_URI = 347,
    KATANA_CSS_FUNCTION = 348,
    KATANA_CSS_ANYFUNCTION = 349,
    KATANA_CSS_CUEFUNCTION = 350,
    KATANA_CSS_NOTFUNCTION = 351,
    KATANA_CSS_DISTRIBUTEDFUNCTION = 352,
    KATANA_CSS_CALCFUNCTION = 353,
    KATANA_CSS_MINFUNCTION = 354,
    KATANA_CSS_MAXFUNCTION = 355,
    KATANA_CSS_HOSTFUNCTION = 356,
    KATANA_CSS_HOSTCONTEXTFUNCTION = 357,
    KATANA_CSS_UNICODERANGE = 358
  };
#endif

/* Value type.  */
#if ! defined KATANASTYPE && ! defined KATANASTYPE_IS_DECLARED
union KATANASTYPE
{

    
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


};
typedef union KATANASTYPE KATANASTYPE;
# define KATANASTYPE_IS_TRIVIAL 1
# define KATANASTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined KATANALTYPE && ! defined KATANALTYPE_IS_DECLARED
typedef struct KATANALTYPE KATANALTYPE;
struct KATANALTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define KATANALTYPE_IS_DECLARED 1
# define KATANALTYPE_IS_TRIVIAL 1
#endif



int katanaparse (void* scanner, struct KatanaInternalParser * parser);

#endif /* !YY_KATANA_SRC_KATANA_TAB_H_INCLUDED  */

/* Second part of user prologue.  */





#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))

/* Stored state numbers (used for stacks). */
typedef yytype_int16 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                            \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined KATANALTYPE_IS_TRIVIAL && KATANALTYPE_IS_TRIVIAL \
             && defined KATANASTYPE_IS_TRIVIAL && KATANASTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
  YYLTYPE yyls_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE) \
             + YYSIZEOF (YYLTYPE)) \
      + 2 * YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  32
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   2239

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  124
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  142
/* YYNRULES -- Number of rules.  */
#define YYNRULES  377
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  722

#define YYUNDEFTOK  2
#define YYMAXUTOK   358


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,   122,     2,   123,     2,     2,
     113,   110,    20,   116,   114,   120,    18,   119,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    17,   112,
       2,   121,   118,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    19,     2,   111,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,   115,    21,   109,   117,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    35,    36,    37,    38,    39,
      40,    41,    42,    43,    44,    45,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      60,    61,    62,    63,    64,    65,    66,    67,    68,    69,
      70,    71,    72,    73,    74,    75,    76,    77,    78,    79,
      80,    81,    82,    83,    84,    85,    86,    87,    88,    89,
      90,    91,    92,    93,    94,    95,    96,    97,    98,    99,
     100,   101,   102,   103,   104,   105,   106,   107,   108
};

#if KATANADEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   314,   314,   315,   316,   317,   318,   319,   320,   321,
     326,   332,   338,   344,   351,   357,   364,   378,   379,   383,
     384,   387,   389,   390,   394,   395,   399,   400,   404,   405,
     409,   410,   413,   415,   420,   423,   425,   432,   433,   434,
     435,   436,   437,   438,   439,   440,   444,   450,   455,   462,
     463,   467,   468,   474,   480,   481,   482,   483,   484,   485,
     486,   487,   491,   495,   502,   508,   515,   518,   524,   530,
     531,   535,   536,   540,   543,   549,   555,   561,   565,   572,
     575,   581,   584,   587,   593,   596,   603,   604,   608,   615,
     618,   622,   626,   630,   638,   642,   649,   655,   661,   667,
     670,   676,   680,   686,   693,   700,   701,   702,   703,   707,
     713,   716,   722,   725,   731,   734,   735,   742,   756,   763,
     769,   776,   780,   784,   791,   792,   799,   800,   806,   810,
     814,   822,   828,   832,   839,   842,   862,   871,   878,   893,
     901,   906,   910,   917,   918,   922,   922,   930,   933,   936,
     939,   942,   945,   948,   951,   954,   957,   960,   963,   966,
     969,   972,   975,   981,   987,   994,  1001,  1009,  1010,  1011,
    1012,  1021,  1022,  1026,  1027,  1031,  1037,  1044,  1050,  1056,
    1062,  1067,  1072,  1079,  1080,  1081,  1094,  1109,  1113,  1117,
    1126,  1131,  1136,  1141,  1149,  1155,  1164,  1168,  1175,  1181,
    1187,  1188,  1194,  1201,  1212,  1213,  1214,  1218,  1228,  1236,
    1245,  1246,  1250,  1256,  1263,  1269,  1276,  1282,  1285,  1288,
    1291,  1294,  1297,  1303,  1304,  1308,  1321,  1334,  1349,  1358,
    1366,  1376,  1380,  1391,  1406,  1425,  1429,  1446,  1449,  1460,
    1464,  1475,  1481,  1484,  1485,  1486,  1489,  1493,  1497,  1504,
    1518,  1525,  1531,  1537,  1544,  1558,  1559,  1563,  1568,  1575,
    1578,  1581,  1587,  1591,  1596,  1600,  1609,  1615,  1621,  1622,
    1628,  1629,  1635,  1636,  1638,  1639,  1640,  1641,  1642,  1643,
    1648,  1649,  1650,  1653,  1657,  1658,  1659,  1660,  1661,  1662,
    1663,  1664,  1665,  1666,  1667,  1668,  1669,  1670,  1671,  1672,
    1673,  1674,  1675,  1676,  1677,  1682,  1683,  1684,  1685,  1686,
    1687,  1688,  1689,  1690,  1694,  1697,  1700,  1706,  1707,  1711,
    1714,  1717,  1720,  1725,  1727,  1731,  1737,  1743,  1747,  1752,
    1757,  1761,  1765,  1772,  1773,  1777,  1781,  1787,  1788,  1792,
    1793,  1794,  1795,  1796,  1800,  1803,  1804,  1805,  1812,  1815,
    1816,  1817,  1821,  1824,  1825,  1829,  1835,  1841,  1845,  1848,
    1848,  1848,  1848,  1848,  1848,  1848,  1848,  1851,  1856,  1861,
    1863,  1864,  1865,  1866,  1869,  1871,  1872,  1873
};
#endif

#if KATANADEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "TOKEN_EOF", "error", "$undefined", "LOWEST_PREC", "UNIMPORTANT_TOK",
  "KATANA_CSS_WHITESPACE", "KATANA_CSS_SGML_CD", "KATANA_CSS_INCLUDES",
  "KATANA_CSS_DASHMATCH", "KATANA_CSS_BEGINSWITH", "KATANA_CSS_ENDSWITH",
  "KATANA_CSS_CONTAINS", "KATANA_CSS_STRING", "KATANA_CSS_IDENT",
  "KATANA_CSS_NTH", "KATANA_CSS_HEX", "KATANA_CSS_IDSEL", "':'", "'.'",
  "'['", "'*'", "'|'", "KATANA_CSS_IMPORT_SYM", "KATANA_CSS_PAGE_SYM",
  "KATANA_CSS_MEDIA_SYM", "KATANA_CSS_SUPPORTS_SYM",
  "KATANA_CSS_FONT_FACE_SYM", "KATANA_CSS_CHARSET_SYM",
  "KATANA_CSS_NAMESPACE_SYM", "KATANA_CSS_VIEWPORT_RULE_SYM",
  "KATANA_INTERNAL_DECLS_SYM", "KATANA_INTERNAL_MEDIALIST_SYM",
  "KATANA_INTERNAL_RULE_SYM", "KATANA_INTERNAL_SELECTOR_SYM",
  "KATANA_INTERNAL_VALUE_SYM", "KATANA_INTERNAL_KEYFRAME_RULE_SYM",
  "KATANA_INTERNAL_KEYFRAME_KEY_LIST_SYM",
  "KATANA_INTERNAL_SUPPORTS_CONDITION_SYM", "KATANA_CSS_KEYFRAMES_SYM",
  "KATANA_CSS_WEBKIT_KATANA_CSS_KEYFRAMES_SYM", "TOPLEFTCORNER_SYM",
  "TOPLEFT_SYM", "TOPCENTER_SYM", "TOPRIGHT_SYM", "TOPRIGHTCORNER_SYM",
  "BOTTOMLEFTCORNER_SYM", "BOTTOMLEFT_SYM", "BOTTOMCENTER_SYM",
  "BOTTOMRIGHT_SYM", "BOTTOMRIGHTCORNER_SYM", "LEFTTOP_SYM",
  "LEFTMIDDLE_SYM", "LEFTBOTTOM_SYM", "RIGHTTOP_SYM", "RIGHTMIDDLE_SYM",
  "RIGHTBOTTOM_SYM", "KATANA_CSS_ATKEYWORD", "KATANA_CSS_IMPORTANT_SYM",
  "KATANA_CSS_MEDIA_ONLY", "KATANA_CSS_MEDIA_NOT", "KATANA_CSS_MEDIA_AND",
  "KATANA_CSS_MEDIA_OR", "KATANA_CSS_SUPPORTS_NOT",
  "KATANA_CSS_SUPPORTS_AND", "KATANA_CSS_SUPPORTS_OR", "KATANA_CSS_REMS",
  "KATANA_CSS_CHS", "KATANA_CSS_QEMS", "KATANA_CSS_EMS", "KATANA_CSS_EXS",
  "KATANA_CSS_PXS", "KATANA_CSS_CMS", "KATANA_CSS_MMS", "KATANA_CSS_INS",
  "KATANA_CSS_PTS", "KATANA_CSS_PCS", "KATANA_CSS_DEGS", "KATANA_CSS_RADS",
  "KATANA_CSS_GRADS", "KATANA_CSS_TURNS", "KATANA_CSS_MSECS",
  "KATANA_CSS_SECS", "KATANA_CSS_HERTZ", "KATANA_CSS_KHERTZ",
  "KATANA_CSS_DIMEN", "KATANA_CSS_INVALIDDIMEN", "KATANA_CSS_PERCENTAGE",
  "KATANA_CSS_FLOATTOKEN", "KATANA_CSS_INTEGER", "KATANA_CSS_VW",
  "KATANA_CSS_VH", "KATANA_CSS_VMIN", "KATANA_CSS_VMAX", "KATANA_CSS_DPPX",
  "KATANA_CSS_DPI", "KATANA_CSS_DPCM", "KATANA_CSS_FR", "KATANA_CSS_URI",
  "KATANA_CSS_FUNCTION", "KATANA_CSS_ANYFUNCTION",
  "KATANA_CSS_CUEFUNCTION", "KATANA_CSS_NOTFUNCTION",
  "KATANA_CSS_DISTRIBUTEDFUNCTION", "KATANA_CSS_CALCFUNCTION",
  "KATANA_CSS_MINFUNCTION", "KATANA_CSS_MAXFUNCTION",
  "KATANA_CSS_HOSTFUNCTION", "KATANA_CSS_HOSTCONTEXTFUNCTION",
  "KATANA_CSS_UNICODERANGE", "'}'", "')'", "']'", "';'", "'('", "','",
  "'{'", "'+'", "'~'", "'>'", "'/'", "'-'", "'='", "'#'", "'%'", "$accept",
  "stylesheet", "internal_rule", "internal_keyframe_rule",
  "internal_keyframe_key_list", "internal_decls", "internal_value",
  "internal_selector", "internal_medialist", "space", "maybe_space",
  "maybe_sgml", "closing_brace", "closing_parenthesis",
  "closing_square_bracket", "semi_or_eof", "maybe_charset", "rule_list",
  "valid_rule", "before_rule", "rule", "block_rule_body",
  "block_rule_list", "block_rule_recovery", "block_valid_rule",
  "block_rule", "before_import_rule", "import_rule_start", "import",
  "namespace", "maybe_ns_prefix", "string_or_uri", "maybe_media_value",
  "media_query_exp", "media_query_exp_list",
  "maybe_and_media_query_exp_list", "maybe_media_restrictor",
  "valid_media_query", "media_query", "maybe_media_list", "media_list",
  "mq_list", "at_rule_body_start", "before_media_rule",
  "at_rule_header_end_maybe_space", "media_rule_start", "media", "medium",
  "supports", "before_supports_rule", "at_supports_rule_header_end",
  "supports_condition", "supports_negation", "supports_conjunction",
  "supports_disjunction", "supports_condition_in_parens",
  "supports_declaration_condition", "before_keyframes_rule",
  "keyframes_rule_start", "webkit_keyframes_rule_start", "keyframes",
  "webkit_keyframe_name", "keyframes_rule", "keyframe_rule_list",
  "keyframe_rule", "key_list", "key", "keyframes_error_recovery",
  "before_page_rule", "page", "page_selector", "declarations_and_margins",
  "margin_box", "$@1", "margin_sym", "before_font_face_rule", "font_face",
  "before_viewport_rule", "viewport", "combinator", "maybe_unary_operator",
  "unary_operator", "maybe_space_before_declaration",
  "before_selector_list", "at_rule_header_end", "at_selector_end",
  "ruleset", "before_selector_group_item", "selector_list", "selector",
  "namespace_selector", "simple_selector", "simple_selector_list",
  "element_name", "specifier_list", "specifier", "class", "attr_name",
  "attr_match_type", "maybe_attr_match_type", "attrib", "match",
  "ident_or_string", "pseudo_page", "pseudo", "selector_recovery",
  "declaration_list", "decl_list", "declaration", "property", "prio",
  "ident_list", "track_names_list", "expr", "expr_recovery",
  "slash_operator", "operator", "term", "unary_term", "function",
  "calc_func_term", "calc_func_operator", "calc_maybe_space",
  "calc_func_paren_expr", "calc_func_expr", "calc_function", "invalid_at",
  "at_rule_recovery", "at_rule_header_recovery", "at_rule_end",
  "regular_invalid_at_rule_header", "invalid_rule", "invalid_rule_header",
  "at_invalid_rule_header_end", "invalid_block",
  "invalid_square_brackets_block", "invalid_parentheses_block",
  "opening_parenthesis", "error_location", "location_label",
  "error_recovery", "rule_error_recovery", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_int16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,    58,    46,    91,
      42,   124,   272,   273,   274,   275,   276,   277,   278,   279,
     280,   281,   282,   283,   284,   285,   286,   287,   288,   289,
     290,   291,   292,   293,   294,   295,   296,   297,   298,   299,
     300,   301,   302,   303,   304,   305,   306,   307,   308,   309,
     310,   311,   312,   313,   314,   315,   316,   317,   318,   319,
     320,   321,   322,   323,   324,   325,   326,   327,   328,   329,
     330,   331,   332,   333,   334,   335,   336,   337,   338,   339,
     340,   341,   342,   343,   344,   345,   346,   347,   348,   349,
     350,   351,   352,   353,   354,   355,   356,   357,   358,   125,
      41,    93,    59,    40,    44,   123,    43,   126,    62,    47,
      45,    61,    35,    37
};
# endif

#define YYPACT_NINF (-373)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-368)

#define yytable_value_is_error(Yyn) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     813,   317,    69,    69,    69,    69,    69,    69,    69,    61,
    -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,
      97,   113,  -373,  -373,  -373,   324,  -373,   735,   934,  1845,
     155,   155,  -373,   330,  -373,  -373,    69,  -373,  -373,   128,
    1944,    31,    63,    55,   251,    69,    69,    69,   153,    43,
    -373,  -373,   230,  -373,  -373,   157,   311,   195,   360,  -373,
     227,  -373,   237,  -373,   240,  -373,   934,  -373,   263,  -373,
    -373,   431,   292,   438,   300,  -373,   333,   105,   583,  -373,
     456,   456,  -373,  -373,  -373,  -373,    69,    69,    69,  -373,
    -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,
    -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,    69,  -373,
    -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,
      69,    69,    69,    69,    69,  -373,  -373,    69,    69,  1955,
      69,   904,  -373,    69,    69,    69,  -373,    69,   264,    69,
     225,  -373,    56,  -373,  -373,   352,   385,    41,  -373,    32,
    -373,  -373,   242,    69,  -373,    69,    69,  -373,    69,    69,
     327,  -373,    69,   314,   104,   245,   356,  -373,   523,  -373,
     348,   366,    69,  -373,  -373,    69,   253,    69,    69,    69,
      69,  -373,  -373,    69,    69,    69,    69,  -373,  -373,   295,
      68,   816,   816,   816,   816,   394,  -373,  -373,   409,    62,
    -373,  -373,   302,   934,    69,    69,    69,   411,   934,  -373,
    -373,   456,   456,   456,  -373,  -373,  -373,  -373,  -373,  -373,
    1021,   659,  -373,    76,  -373,  -373,    69,    69,  -373,  -373,
      69,    69,   306,  1845,  -373,  -373,  -373,  -373,   426,    69,
      69,  -373,  -373,  -373,  2039,  -373,  -373,  -373,  -373,  -373,
    -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,
    -373,  -373,  -373,  -373,  -373,  1318,    69,  -373,  -373,  -373,
    -373,  -373,  -373,  -373,  -373,   424,   380,  -373,    69,  -373,
      69,  -373,   328,  -373,    69,    43,  -373,  -373,  -373,  -373,
       5,  -373,  -373,  -373,   331,   332,   132,   334,   337,   302,
     816,   440,   280,    70,   934,    70,   934,    70,   934,    70,
     934,    70,  -373,  -373,   215,   300,   442,   106,  -373,  -373,
    -373,    69,  -373,  -373,  -373,  -373,   338,  -373,   456,  -373,
    -373,  -373,  -373,   792,    70,    69,  2143,    70,  -373,  -373,
    -373,   451,    69,  -373,   260,    70,  -373,  -373,  -373,  -373,
    1845,  -373,  -373,   155,   248,  -373,   396,  -373,   100,    50,
     436,   267,   289,   439,   441,   437,  -373,  -373,  1459,   330,
    1049,  1153,  1497,  -373,  -373,  -373,  -373,  -373,  1355,  1120,
     682,  1153,    69,    69,   405,  -373,  -373,  -373,    69,  -373,
      69,   556,  -373,    69,   318,  -373,  -373,   413,   416,   335,
    -373,  -373,  -373,   290,   468,  -373,    69,  -373,  -373,   367,
     934,    70,  -373,    69,    69,   401,  -373,  -373,    69,  -373,
      69,  -373,    69,  -373,    69,  -373,   564,  -373,    69,   106,
    -373,  -373,  -373,  -373,  -373,  -373,  -373,    69,  -373,    69,
    -373,  -373,  -373,   659,  -373,  -373,    94,   137,  2087,    27,
    -373,    69,  -373,  -373,  -373,    69,    90,  -373,  -373,  -373,
     -12,   134,  -373,  -373,   291,    52,    52,   185,  -373,  -373,
    -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,
    -373,  -373,  -373,  -373,  -373,  -373,   489,  -373,  -373,  -373,
    -373,  -373,  -373,  1671,  -373,   475,   382,    69,   822,  -373,
    -373,    41,    32,    69,   400,  -373,    35,   412,    69,    69,
      69,    69,    69,    69,  -373,    69,  -373,   418,  -373,    69,
      69,  -373,    69,  -373,    70,    70,    69,   160,    70,   160,
     160,  -373,    69,   398,   934,  -373,  1535,    70,   451,    69,
      69,  -373,  -373,    69,    69,  -373,  -373,  -373,  -373,  1620,
    -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,  1440,    69,
    1030,    69,    70,  -373,   382,  -373,  -373,  -373,  -373,  -373,
    -373,  -373,    69,    70,  -373,   400,   400,   400,   400,  -373,
    -373,  -373,  -373,   248,   248,    69,   160,  -373,  -373,    70,
      69,  -373,  -373,  -373,  -373,   398,  -373,  -373,    69,   105,
    -373,    27,    97,    97,  -373,  -373,   419,  -373,  -373,  -373,
    1845,  -373,    69,    90,    98,  1153,   498,    69,    69,  -373,
    -373,  -373,  -373,  -373,  -373,    69,    90,    90,   248,  -373,
    -373,   934,    69,   507,  -373,  -373,   939,  1477,  1758,   380,
    -373,  2095,  -373,  -373,    69,    69,  -373,  -373,    90,    78,
      90,  1962,  -373,  -373,    90,  -373,   507,    69,  -373,    62,
    -373,  -373,   489,  -373,   591,  -373,  -373,  -373,  -373,  -373,
    -373,  -373,  -373,  -373,  -373,   330,  -373,  1219,    90,  -373,
    -373,    69,   419,  -373,  1336,  -373,  -373,    62,  -373,  -373,
    -373,   -12,   185,  -373,  1671,  -373,  1562,  -373,    69,  -373,
      69,  -373,  -373,  1601,  1153,    70,  -373,  -373,  1962,    69,
     419,    69,    69,  -373,  -373,   420,  -373,  -373,    69,   248,
      90,  -373
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_int16 yydefact[] =
{
      32,     0,    19,    19,    19,    19,    19,    19,    19,     0,
       4,     8,     9,     3,     7,     5,     6,    21,   367,    17,
      20,     0,    34,   355,   175,     0,   368,   176,     0,     0,
     172,   172,     1,    35,   374,    18,    19,   355,   367,     0,
       0,   244,     0,     0,     0,    19,    19,    19,     0,     0,
      43,    42,     0,    38,    44,     0,     0,     0,     0,    41,
       0,    39,     0,    40,     0,    45,     0,    37,   198,   203,
     202,   367,     0,     0,   199,   187,   178,   181,     0,   183,
     190,   192,   200,   204,   205,   206,    19,    19,    19,   304,
     305,   302,   301,   303,   287,   288,   289,   290,   291,   292,
     293,   294,   295,   296,   297,   298,   299,   300,    19,   286,
     285,   284,   306,   307,   308,   309,   310,   311,   312,   313,
      19,    19,    19,    19,    19,   174,   173,    19,    19,     0,
      19,     0,   262,    19,    19,    19,   135,    19,     0,    19,
       0,   171,     0,    23,    22,    46,     0,     0,   335,     0,
     369,    13,   245,    19,   367,    19,    19,   367,    19,    19,
       0,    77,    19,     0,     0,    91,     0,    90,     0,    97,
      69,     0,    19,    71,    72,    19,     0,    19,    19,    19,
      19,   125,   124,    19,    19,    19,    19,   178,   189,   367,
       0,     0,     0,     0,     0,     0,   207,   367,     0,     0,
     188,    15,     0,   184,    19,    19,    19,     0,     0,   198,
     199,   193,   195,   191,   201,   272,   273,   278,   274,   276,
       0,     0,   277,     0,   279,   282,    19,    19,   283,    14,
      19,    19,   268,     0,   264,   270,   280,   281,     0,    19,
      19,   132,   134,    12,     0,    21,   375,   369,   360,   362,
     364,   363,   365,   361,   366,   359,   376,   377,   369,    31,
      30,    33,   369,   337,   338,     0,    19,   247,   369,   367,
     254,   374,    82,    83,   369,     0,    84,   101,    19,   367,
      19,    16,    92,    99,    19,     0,    10,    65,   368,   177,
       0,   120,   121,    98,     0,     0,   142,     0,     0,   177,
       0,     0,   172,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   226,   369,    19,     0,     0,     0,    29,    28,
     216,    19,   185,   167,   168,   169,     0,   186,   194,    27,
     367,    26,   315,     0,     0,    19,     0,     0,   317,   327,
     330,   323,    19,   259,     0,     0,   275,   271,   269,   267,
       0,   263,    11,   172,     0,   367,     0,    47,     0,     0,
       0,     0,     0,     0,     0,     0,   355,    48,     0,    36,
       0,     0,     0,   370,   371,   372,   373,   248,     0,     0,
       0,     0,    19,    19,    79,    85,   374,   368,    19,    70,
      19,     0,    96,    19,     0,   104,   106,   107,   108,   105,
     115,    96,    96,    19,     0,   177,    19,    96,    96,     0,
       0,     0,   227,    19,    19,     0,   235,   196,    19,   231,
      19,   237,    19,   239,    19,   241,     0,   208,    19,     0,
     218,   219,   220,   221,   222,   217,   212,    19,   180,    19,
     369,   314,   316,     0,   318,   332,   324,     0,     0,     0,
     257,    19,   260,   261,   265,    19,     0,   374,   346,   345,
       0,     0,   339,   340,     0,     0,     0,     0,   147,   148,
     149,   150,   151,   152,   153,   154,   155,   156,   157,   158,
     159,   160,   161,   162,   333,   334,     0,   357,   358,    25,
      24,   356,   369,   256,    76,    73,     0,    19,     0,    94,
     368,     0,     0,    19,     0,   367,     0,     0,    19,    19,
      19,    19,    19,    19,   139,    19,   225,     0,   141,    19,
      19,    96,    19,   229,     0,     0,    19,     0,     0,     0,
       0,   214,    19,     0,     0,   170,     0,     0,   323,     0,
       0,   328,   329,    19,    19,   331,   258,   133,   131,     0,
     351,   367,   341,   342,   344,   349,   350,   347,     0,    19,
       0,    19,     0,    78,     0,    95,    68,    66,    67,    51,
     109,   369,    19,     0,    96,     0,     0,     0,     0,   368,
     368,   140,    96,     0,     0,    19,     0,   234,   232,     0,
      19,   230,   236,   238,   240,     0,   224,   223,    19,   182,
     326,     0,   319,   320,   321,   322,     0,   374,   255,   369,
       0,    75,    19,     0,    46,     0,     0,    19,    19,   111,
     113,   110,   112,   128,   128,    19,     0,     0,     0,   228,
     233,     0,    19,   211,   325,   348,     0,     0,    74,    80,
     100,     0,    50,    21,    19,    19,   114,    51,     0,     0,
       0,     0,   164,   166,     0,   197,   211,    19,   210,     0,
     367,    62,     0,    61,     0,    57,    59,    58,    55,    56,
      60,    54,   355,    63,    53,    52,   116,     0,     0,   122,
     374,    19,   127,   123,     0,   143,   179,     0,   209,   213,
     374,   354,   353,   369,   256,   102,     0,   368,    19,   138,
      19,   145,   215,     0,     0,     0,   129,   368,     0,    19,
     352,    19,    19,   130,   144,     0,   118,   117,    19,     0,
       0,   146
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,  -373,  -305,
      -1,  -228,  -372,   241,  -299,  -125,  -373,  -373,   296,   -75,
    -373,  -106,  -373,  -373,  -373,  -373,  -373,  -223,  -373,   -94,
    -373,   266,  -373,    53,   -11,  -373,  -373,  -373,   386,   -44,
    -373,  -373,  -342,  -373,  -152,  -221,   -82,  -373,   -79,   539,
    -373,    64,  -373,  -373,  -373,   -72,  -373,  -373,   540,   549,
     -64,  -373,   -45,  -373,   -69,   559,   234,  -373,   566,   -47,
    -373,  -373,  -373,  -373,   -78,   578,   -34,   581,   -32,  -373,
     308,   -15,  -234,  -373,  -224,   432,   -28,  -373,   552,    87,
     427,    -8,   -66,   548,   -26,   -62,  -373,   312,  -373,   -29,
    -373,   200,    38,   236,  -373,   -98,  -325,  -373,   590,  -373,
     -57,  -373,  -373,  -207,  -181,   408,  -373,  -122,   -90,  -373,
     193,  -373,   108,   194,   204,  -373,  -373,  -373,    13,  -373,
       7,    10,  -373,   -27,  -137,  -135,  -108,  -373,    12,  -263,
    -225,  -245
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     9,    10,    11,    12,    13,    14,    15,    16,    20,
     293,    33,   491,   332,   320,   261,    17,   145,    47,   244,
     245,   613,   614,   642,   661,   643,    48,    49,    50,    51,
     285,   175,   562,   161,   162,   385,   163,   164,   165,   166,
     167,   168,   503,   283,   297,    52,    53,   278,    54,   360,
     507,   395,   396,   397,   398,   399,   400,    56,   361,   362,
      59,   183,   648,   649,   137,   138,   139,   682,   363,    61,
     405,   684,   700,   709,   485,   364,    63,   365,    65,   208,
     140,   129,    25,    66,   392,   202,    67,   534,    76,    77,
      78,   417,   418,    80,    81,    82,    83,   317,   658,   659,
      84,   437,   598,   406,    85,   199,    39,    40,    41,    42,
     560,   344,   130,   131,   334,   232,   233,   132,   133,   134,
     339,   448,   449,   340,   341,   135,   486,    22,   459,   148,
     366,   367,   674,    37,   374,   375,   376,   258,    43,    44,
     265,   146
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      21,    24,    26,    27,    28,    29,    30,    31,   176,   234,
     149,   256,   264,   333,    23,   141,   141,   369,   436,   214,
      79,   358,   370,   359,   263,   391,   380,   329,   294,   456,
      34,   295,   259,   371,   298,   147,   447,   372,   257,   227,
     337,   259,   345,   378,   169,   170,   171,   543,   572,   381,
     150,   157,   212,    18,   213,   173,   243,    19,    79,   512,
     513,    32,   318,   -81,   154,   519,   520,   393,   156,   197,
     329,   487,   198,    19,    19,   409,   329,   330,  -126,   680,
     155,   -19,   -19,   195,   548,   215,   216,   217,   426,   342,
     489,   136,   303,   305,   307,   309,   311,   393,   -49,   -17,
     550,    18,    35,   289,   -86,   279,   318,   218,   158,   159,
     203,   351,   173,   430,   431,   432,   433,   434,   394,   219,
     220,   221,   222,   223,   499,    36,   224,   225,   151,   228,
     531,   338,   235,   236,   237,   551,   238,   331,   241,    19,
     174,   498,    35,   153,   260,   403,   544,   262,   394,   404,
     214,   214,   267,   260,   269,   270,   -19,   272,   273,   275,
     329,   276,   -89,   160,  -172,   -89,   268,   -19,   136,   271,
     239,   287,   493,   319,   288,   172,   290,   291,   292,   585,
     331,   517,   177,   296,   -19,   328,   331,  -126,   -19,   302,
     304,   306,   308,   310,   125,   322,   -19,   174,   126,   490,
     327,   301,   411,   323,   324,   325,   336,   -49,   180,   313,
     -17,   234,   549,   -86,   -17,   536,   -86,   319,   -86,   -86,
      19,   204,   205,   206,   207,   346,   347,   435,   454,   348,
     349,   157,   618,   447,   602,   603,   188,   565,   353,   354,
     625,   640,   422,   -81,   424,   256,   444,   -19,  -243,    38,
     184,   -89,   157,   539,   652,   653,   368,   540,   626,   627,
     329,  -367,   537,   185,   -81,   377,   214,   558,    18,   186,
     331,   125,   257,   451,   590,   126,   679,   384,   683,   387,
     180,   379,   686,   389,   188,   583,   584,   141,   158,   159,
      18,   386,    18,   413,   414,    19,    19,   555,   420,   410,
     262,   181,   182,   654,   -19,   196,   695,   404,   -19,   158,
     159,   242,   699,   427,   298,   460,   623,   624,    18,   505,
     438,   200,    19,    19,  -243,    38,   685,   277,   274,   -19,
     556,   -19,    19,   201,   443,   143,   144,  -367,   141,   467,
     -19,   450,   440,   160,   522,   -89,   615,   502,   721,   178,
     179,   628,    -2,   338,   266,   170,   281,  -243,   338,   280,
     689,   284,   636,   256,   160,   568,   286,   457,   289,   458,
     331,   234,   181,   182,   462,   463,   566,   567,   239,   240,
     -19,   495,   496,   714,   637,  -336,   246,   500,   702,   501,
     257,   651,   504,   506,   720,   300,   125,    18,   510,   511,
     126,    19,   514,   638,   247,   518,   -19,   312,   -19,   -19,
     596,   597,   524,   525,   256,   675,   321,   527,   662,   528,
     664,   529,   314,   530,   326,   231,   352,   427,   336,   315,
      75,   -19,   570,   336,   706,   696,   533,   382,   535,   197,
     383,   257,   388,    19,   713,   703,   401,   402,   189,   407,
     546,   -19,   408,   412,   547,   428,   446,   439,   -19,   -19,
     290,   461,   464,   296,   343,   497,   466,   465,   704,   635,
     694,    69,    70,    71,    72,    73,   508,   552,   553,   554,
     509,   516,   521,   248,   249,   250,   251,   252,   253,   526,
      18,   254,   561,   -19,  -336,   160,   564,  -336,   255,   557,
    -336,   256,   569,   619,   620,   621,   622,   575,   576,   577,
     578,   579,   580,   394,   581,   645,   234,   571,    24,    24,
     657,   586,   606,   -93,   157,   589,    79,   574,   257,   190,
     191,   595,   192,   582,   262,   718,   -81,   193,   194,   641,
     357,   678,   604,   605,   416,   698,   419,   663,   421,   563,
     423,   390,   425,   612,   282,   556,   -89,   157,   608,   665,
     610,   256,   666,   607,  -242,   373,    55,    57,   256,   -81,
     573,   616,   234,   635,   441,   442,    58,   667,   445,   650,
     681,   158,   159,   247,    24,   452,   453,   455,   257,   631,
     142,   -89,   157,    60,   668,   257,   209,   633,    69,    70,
      71,    72,    73,   210,   -81,    62,   701,   669,    64,   670,
     415,   639,   488,   671,   158,   159,   646,   647,   187,   299,
     691,   599,   494,   655,    24,   316,   211,   687,   429,   532,
     152,   656,   -93,   632,   141,   -93,   160,   705,   -93,   515,
     350,   541,   542,   676,   677,   692,   601,   538,   672,   158,
     159,   673,   523,   368,     0,     0,   688,     0,     0,     0,
     330,     0,   248,   249,   250,   251,   252,   253,   -89,   160,
     254,   -89,   690,     0,  -242,  -242,   710,   255,     0,   262,
     697,     0,   -88,   246,     0,     0,     0,     0,     0,     0,
     545,     0,     0,     0,     0,     0,     0,   707,     0,   708,
     -89,   247,     0,   -89,   160,     0,   -89,     0,   715,     0,
     716,   717,     0,     0,     0,     0,     0,   719,     0,     0,
       0,     0,     0,     0,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,   103,   104,
     105,   106,   107,     0,     0,   109,   110,   111,   112,   113,
     114,   115,   116,   117,   118,   119,     0,   -64,  -137,    45,
    -103,  -163,     0,    46,  -165,   587,   588,     0,   591,   592,
     593,   594,   335,  -119,  -119,   125,     0,     0,   600,   126,
     248,   249,   250,   251,   252,   253,     0,     0,   254,     0,
       0,   -88,   329,     0,   -88,   255,   -88,   -88,     0,     0,
       0,     0,     0,   611,    86,    87,     0,    88,     0,     0,
       0,     0,     0,     0,   617,     0,     0,   197,     0,     0,
       0,    19,   -87,   246,     0,     0,     0,   629,     0,   -19,
     630,   -19,   -19,   -19,   -19,   -19,   -19,   -19,     0,     0,
       1,   247,   634,     2,     3,     4,     5,     6,     7,     8,
       0,     0,     0,     0,     0,     0,   644,    89,    90,    91,
      92,    93,    94,    95,    96,    97,    98,    99,   100,   101,
     102,   103,   104,   105,   106,   107,   108,     0,   109,   110,
     111,   112,   113,   114,   115,   116,   117,   118,   119,   120,
     121,     0,     0,     0,     0,   122,     0,     0,     0,     0,
     123,     0,   331,     0,   229,   124,   230,     0,   125,     0,
       0,   231,   126,     0,   127,   128,    86,    87,     0,    88,
     248,   249,   250,   251,   252,   253,     0,     0,   254,     0,
       0,   -87,     0,     0,   -87,   255,   -87,   -87,     0,  -343,
     246,     0,     0,     0,     0,   711,   712,    68,     0,    69,
      70,    71,    72,    73,    74,    75,     0,     0,   247,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    89,
      90,    91,    92,    93,    94,    95,    96,    97,    98,    99,
     100,   101,   102,   103,   104,   105,   106,   107,   108,     0,
     109,   110,   111,   112,   113,   114,   115,   116,   117,   118,
     119,   120,   121,     0,     0,     0,     0,   122,     0,     0,
       0,     0,   123,     0,     0,     0,     0,   124,   230,     0,
     125,   329,   330,   231,   126,     0,   127,   128,     0,     0,
    -249,   609,     0,    86,    87,     0,    88,   248,   249,   250,
     251,   252,   253,     0,     0,   254,     0,     0,  -343,   318,
     373,  -343,   255,     0,  -343,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   247,     0,
    -249,  -249,  -249,  -249,  -249,  -249,  -249,  -249,  -249,  -249,
    -249,  -249,  -249,  -249,  -249,  -249,    89,    90,    91,    92,
      93,    94,    95,    96,    97,    98,    99,   100,   101,   102,
     103,   104,   105,   106,   107,   108,     0,   109,   110,   111,
     112,   113,   114,   115,   116,   117,   118,   119,   120,   121,
       0,   492,     0,     0,   122,     0,     0,     0,     0,   123,
       0,   331,    86,    87,   124,    88,     0,   125,     0,  -249,
       0,   126,  -249,   127,   128,     0,     0,   248,   249,   250,
     251,   252,   253,   329,   373,   254,     0,     0,     0,     0,
     319,     0,   255,     0,   262,     0,     0,     0,     0,     0,
       0,     0,   247,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    89,    90,    91,    92,    93,
      94,    95,    96,    97,    98,    99,   100,   101,   102,   103,
     104,   105,   106,   107,   108,     0,   109,   110,   111,   112,
     113,   114,   115,   116,   117,   118,   119,   120,   121,     0,
     693,     0,     0,   122,     0,     0,     0,     0,   123,     0,
       0,    86,    87,   124,    88,     0,   125,     0,     0,     0,
     126,     0,   127,   128,     0,     0,     0,     0,     0,     0,
       0,   248,   249,   250,   251,   252,   253,     0,     0,   254,
       0,     0,     0,   331,     0,     0,   255,     0,   262,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,   103,   104,
     105,   106,   107,   108,     0,   109,   110,   111,   112,   113,
     114,   115,   116,   117,   118,   119,   120,   121,  -253,   373,
       0,     0,   122,     0,     0,     0,     0,   123,     0,     0,
       0,     0,   124,     0,     0,   125,   489,   247,     0,   126,
       0,   127,   128,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,  -252,   373,     0,  -253,  -253,
    -253,  -253,  -253,  -253,  -253,  -253,  -253,  -253,  -253,  -253,
    -253,  -253,  -253,  -253,   247,     0,   468,   469,   470,   471,
     472,   473,   474,   475,   476,   477,   478,   479,   480,   481,
     482,   483,     0,     0,     0,  -252,  -252,  -252,  -252,  -252,
    -252,  -252,  -252,  -252,  -252,  -252,  -252,  -252,  -252,  -252,
    -252,     0,     0,     0,     0,     0,   248,   249,   250,   251,
     252,   253,     0,     0,   254,     0,     0,  -253,     0,     0,
    -253,   255,     0,   262,     0,     0,     0,     0,     0,     0,
    -251,   373,     0,     0,     0,   490,     0,     0,     0,     0,
       0,     0,     0,   248,   249,   250,   251,   252,   253,   247,
       0,   254,     0,     0,  -252,     0,     0,  -252,   255,     0,
     262,     0,     0,     0,     0,     0,     0,  -250,   373,     0,
    -251,  -251,  -251,  -251,  -251,  -251,  -251,  -251,  -251,  -251,
    -251,  -251,  -251,  -251,  -251,  -251,   247,   489,   373,   468,
     469,   470,   471,   472,   473,   474,   475,   476,   477,   478,
     479,   480,   481,   482,   483,   484,   247,  -250,  -250,  -250,
    -250,  -250,  -250,  -250,  -250,  -250,  -250,  -250,  -250,  -250,
    -250,  -250,  -250,     0,     0,  -266,   373,     0,   248,   249,
     250,   251,   252,   253,     0,     0,   254,     0,     0,  -251,
       0,     0,  -251,   255,   247,   262,     0,     0,     0,     0,
       0,     0,  -136,   246,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   248,   249,   250,   251,   252,
     253,   247,     0,   254,     0,     0,  -250,     0,     0,  -250,
     255,     0,   262,     0,     0,   248,   249,   250,   251,   252,
     253,  -355,   246,   254,     0,     0,   490,     0,     0,     0,
     255,     0,   262,     0,     0,     0,     0,     0,     0,     0,
     247,   246,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   248,   249,   250,   251,   252,   253,   247,
       0,   254,     0,     0,     0,  -266,     0,     0,   255,     0,
     262,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     248,   249,   250,   251,   252,   253,     0,     0,   254,     0,
       0,  -136,     0,     0,     0,   255,     0,  -136,     0,     0,
       0,     0,     0,    86,    87,     0,    88,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   248,
     249,   250,   251,   252,   253,     0,     0,   254,     0,     0,
    -355,     0,     0,     0,   255,     0,  -355,     0,   248,   249,
     250,   251,   252,   253,     0,     0,   254,     0,   559,     0,
       0,     0,     0,   255,     0,  -355,    89,    90,    91,    92,
      93,    94,    95,    96,    97,    98,    99,   100,   101,   102,
     103,   104,   105,   106,   107,   108,     0,   109,   110,   111,
     112,   113,   114,   115,   116,   117,   118,   119,   120,   121,
      86,    87,     0,    88,   122,     0,     0,     0,     0,   123,
       0,     0,     0,     0,   124,   230,     0,   125,     0,     0,
     231,   126,     0,   127,   128,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    89,    90,    91,    92,    93,    94,    95,
      96,    97,    98,    99,   100,   101,   102,   103,   104,   105,
     106,   107,   108,     0,   109,   110,   111,   112,   113,   114,
     115,   116,   117,   118,   119,   120,   121,    86,    87,     0,
      88,   122,     0,     0,     0,     0,   123,     0,     0,     0,
       0,   124,   230,     0,   125,     0,     0,   231,   126,     0,
     127,   128,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      89,    90,    91,    92,    93,    94,    95,    96,    97,    98,
      99,   100,   101,   102,   103,   104,   105,   106,   107,   108,
       0,   109,   110,   111,   112,   113,   114,   115,   116,   117,
     118,   119,   120,   121,  -246,    38,     0,     0,   122,     0,
       0,     0,     0,   123,     0,     0,     0,  -367,   124,     0,
       0,   125,  -243,    38,     0,   126,     0,   127,   128,     0,
       0,     0,     0,     0,     0,  -367,     0,     0,     0,     0,
       0,     0,     0,     0,  -246,  -246,  -246,  -246,  -246,  -246,
    -246,  -246,  -246,  -246,  -246,  -246,  -246,  -246,  -246,  -246,
       0,     0,  -243,  -243,  -243,  -243,  -243,  -243,  -243,  -243,
    -243,  -243,  -243,  -243,  -243,  -243,  -243,  -243,     0,     0,
      89,    90,    91,    92,    93,    94,    95,    96,    97,    98,
      99,   100,   101,   102,   103,   104,   105,   106,   107,   226,
     355,   109,   110,   111,   112,   113,   114,   115,   116,   117,
     118,   119,  -176,  -246,  -176,  -176,  -176,  -176,  -176,  -176,
    -176,   -64,  -137,    45,  -103,  -163,     0,   356,  -165,     0,
       0,  -243,     0,     0,     0,     0,     0,  -119,  -119,  -367,
    -367,  -367,  -367,  -367,  -367,  -367,  -367,  -367,  -367,  -367,
    -367,  -367,  -367,  -367,  -367,  -367,   660,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,  -176,     0,
    -176,  -176,  -176,  -176,  -176,  -176,  -176,   -64,  -137,    45,
    -103,  -163,     0,   356,  -165,     0,     0,     0,     0,     0,
       0,     0,     0,  -119,  -119,  -367,  -367,  -367,  -367,  -367,
    -367,  -367,  -367,  -367,  -367,  -367,  -367,  -367,  -367,  -367,
    -367,  -367,    89,    90,    91,    92,    93,    94,    95,    96,
      97,    98,    99,   100,   101,   102,   103,   104,   105,   106,
     107,     0,     0,   109,   110,   111,   112,   113,   114,   115,
     116,   117,   118,   119,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     335,     0,     0,   125,     0,     0,     0,   126,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,   103,   104,   105,   106,   107,     0,     0,   109,
     110,   111,   112,   113,   114,   115,   116,   117,   118,   119
};

static const yytype_int16 yycheck[] =
{
       1,     2,     3,     4,     5,     6,     7,     8,    52,   131,
      37,   146,   149,   220,     1,    30,    31,   245,   317,    81,
      28,   244,   247,   244,   149,   288,   271,     0,   180,   354,
      18,   183,     0,   258,   186,    36,   341,   262,   146,   129,
     221,     0,   223,   268,    45,    46,    47,    20,    13,   274,
      38,     1,    78,     1,    80,    12,     0,     5,    66,   401,
     402,     0,     0,    13,     1,   407,   408,    62,    13,     1,
       0,   370,    73,     5,     5,   299,     0,     1,     0,     1,
      17,    13,    14,    71,   456,    86,    87,    88,   313,    13,
       0,    13,   190,   191,   192,   193,   194,    62,     0,     5,
     112,     1,     5,   115,     0,     1,     0,   108,    58,    59,
       5,   233,    12,     7,     8,     9,    10,    11,   113,   120,
     121,   122,   123,   124,   387,    12,   127,   128,     0,   130,
     429,   221,   133,   134,   135,     1,   137,   110,   139,     5,
      97,   386,     5,   112,   112,    13,   119,   115,   113,    17,
     212,   213,   153,   112,   155,   156,    88,   158,   159,   160,
       0,   162,   112,   113,    86,   115,   154,   115,    13,   157,
     114,   172,   379,   111,   175,    22,   177,   178,   179,   521,
     110,   405,    25,   184,   116,   211,   110,   109,   120,   190,
     191,   192,   193,   194,   116,   203,    62,    97,   120,   109,
     208,   189,   300,   204,   205,   206,   221,   109,    13,   197,
     116,   333,   457,   109,   120,   440,   112,   111,   114,   115,
       5,   116,   117,   118,   119,   226,   227,   121,   350,   230,
     231,     1,   574,   538,   539,   540,    21,   500,   239,   240,
     582,   613,   308,    13,   310,   380,   336,   113,     0,     1,
      23,     0,     1,   116,   626,   627,   244,   120,   583,   584,
       0,    13,   443,    26,    13,   266,   328,   492,     1,    29,
     110,   116,   380,    13,   114,   120,   648,   278,   650,   280,
      13,   269,   654,   284,    21,   519,   520,   302,    58,    59,
       1,   279,     1,    13,    14,     5,     5,   112,   306,   300,
     115,    12,    13,   628,    13,    13,   678,    17,    17,    58,
      59,    86,   684,   314,   466,   359,   579,   580,     1,     1,
     321,    21,     5,     5,     0,     1,   651,    13,     1,    12,
     467,    13,     5,     0,   335,     5,     6,    13,   353,   366,
      13,   342,   330,   113,   410,   115,   571,   391,   720,    38,
      39,   585,     0,   443,   112,   356,     0,   109,   448,   114,
     659,    13,   607,   498,   113,   502,     0,   355,   115,   356,
     110,   493,    12,    13,   361,   362,   501,   502,   114,   115,
      62,   382,   383,   708,   609,     0,     1,   388,   687,   390,
     498,   625,   393,   394,   719,   100,   116,     1,    63,    64,
     120,     5,   403,   610,    19,   406,   115,    13,    12,    13,
      12,    13,   413,   414,   549,   643,   114,   418,   641,   420,
     641,   422,    13,   424,    13,   119,     0,   428,   443,    20,
      21,   113,   504,   448,   697,   680,   437,    13,   439,     1,
      60,   549,   114,     5,   707,   690,   115,   115,    17,   115,
     451,    13,   115,    13,   455,    13,     5,   119,    20,    21,
     461,    25,    23,   464,   223,    60,    29,    26,   693,   606,
     677,    15,    16,    17,    18,    19,    63,   464,   465,   466,
      64,    13,   115,    98,    99,   100,   101,   102,   103,    88,
       1,   106,    17,    97,   109,   113,   497,   112,   113,   486,
     115,   636,   503,   575,   576,   577,   578,   508,   509,   510,
     511,   512,   513,   113,   515,    17,   638,   505,   519,   520,
      13,   522,   549,     0,     1,   526,   534,   115,   636,    98,
      99,   532,   101,   115,   115,   115,    13,   106,   107,   614,
     244,   647,   543,   544,   303,   682,   305,   641,   307,   496,
     309,   285,   311,   564,   168,   692,     0,     1,   559,   641,
     561,   696,   641,   551,     0,     1,    27,    27,   703,    13,
     506,   572,   694,   710,   333,   334,    27,   641,   337,   624,
     649,    58,    59,    19,   585,   344,   345,   353,   696,   590,
      31,     0,     1,    27,   641,   703,    13,   598,    15,    16,
      17,    18,    19,    20,    13,    27,   684,   641,    27,   641,
     302,   612,   371,   641,    58,    59,   617,   618,    66,   187,
     664,   534,   381,   631,   625,   198,    78,   656,   316,   429,
      40,   632,   109,   595,   649,   112,   113,   694,   115,   403,
     232,   448,   448,   644,   645,   672,   538,   443,   641,    58,
      59,   641,   411,   641,    -1,    -1,   657,    -1,    -1,    -1,
       1,    -1,    98,    99,   100,   101,   102,   103,   112,   113,
     106,   115,   660,    -1,   110,   111,   703,   113,    -1,   115,
     681,    -1,     0,     1,    -1,    -1,    -1,    -1,    -1,    -1,
     449,    -1,    -1,    -1,    -1,    -1,    -1,   698,    -1,   700,
     109,    19,    -1,   112,   113,    -1,   115,    -1,   709,    -1,
     711,   712,    -1,    -1,    -1,    -1,    -1,   718,    -1,    -1,
      -1,    -1,    -1,    -1,    65,    66,    67,    68,    69,    70,
      71,    72,    73,    74,    75,    76,    77,    78,    79,    80,
      81,    82,    83,    -1,    -1,    86,    87,    88,    89,    90,
      91,    92,    93,    94,    95,    96,    -1,    22,    23,    24,
      25,    26,    -1,    28,    29,   524,   525,    -1,   527,   528,
     529,   530,   113,    38,    39,   116,    -1,    -1,   537,   120,
      98,    99,   100,   101,   102,   103,    -1,    -1,   106,    -1,
      -1,   109,     0,    -1,   112,   113,   114,   115,    -1,    -1,
      -1,    -1,    -1,   562,    12,    13,    -1,    15,    -1,    -1,
      -1,    -1,    -1,    -1,   573,    -1,    -1,     1,    -1,    -1,
      -1,     5,     0,     1,    -1,    -1,    -1,   586,    -1,    13,
     589,    15,    16,    17,    18,    19,    20,    21,    -1,    -1,
      27,    19,   601,    30,    31,    32,    33,    34,    35,    36,
      -1,    -1,    -1,    -1,    -1,    -1,   615,    65,    66,    67,
      68,    69,    70,    71,    72,    73,    74,    75,    76,    77,
      78,    79,    80,    81,    82,    83,    84,    -1,    86,    87,
      88,    89,    90,    91,    92,    93,    94,    95,    96,    97,
      98,    -1,    -1,    -1,    -1,   103,    -1,    -1,    -1,    -1,
     108,    -1,   110,    -1,     0,   113,   114,    -1,   116,    -1,
      -1,   119,   120,    -1,   122,   123,    12,    13,    -1,    15,
      98,    99,   100,   101,   102,   103,    -1,    -1,   106,    -1,
      -1,   109,    -1,    -1,   112,   113,   114,   115,    -1,     0,
       1,    -1,    -1,    -1,    -1,   704,   705,    13,    -1,    15,
      16,    17,    18,    19,    20,    21,    -1,    -1,    19,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    65,
      66,    67,    68,    69,    70,    71,    72,    73,    74,    75,
      76,    77,    78,    79,    80,    81,    82,    83,    84,    -1,
      86,    87,    88,    89,    90,    91,    92,    93,    94,    95,
      96,    97,    98,    -1,    -1,    -1,    -1,   103,    -1,    -1,
      -1,    -1,   108,    -1,    -1,    -1,    -1,   113,   114,    -1,
     116,     0,     1,   119,   120,    -1,   122,   123,    -1,    -1,
       0,     1,    -1,    12,    13,    -1,    15,    98,    99,   100,
     101,   102,   103,    -1,    -1,   106,    -1,    -1,   109,     0,
       1,   112,   113,    -1,   115,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    19,    -1,
      40,    41,    42,    43,    44,    45,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    65,    66,    67,    68,
      69,    70,    71,    72,    73,    74,    75,    76,    77,    78,
      79,    80,    81,    82,    83,    84,    -1,    86,    87,    88,
      89,    90,    91,    92,    93,    94,    95,    96,    97,    98,
      -1,     1,    -1,    -1,   103,    -1,    -1,    -1,    -1,   108,
      -1,   110,    12,    13,   113,    15,    -1,   116,    -1,   109,
      -1,   120,   112,   122,   123,    -1,    -1,    98,    99,   100,
     101,   102,   103,     0,     1,   106,    -1,    -1,    -1,    -1,
     111,    -1,   113,    -1,   115,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    19,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    65,    66,    67,    68,    69,
      70,    71,    72,    73,    74,    75,    76,    77,    78,    79,
      80,    81,    82,    83,    84,    -1,    86,    87,    88,    89,
      90,    91,    92,    93,    94,    95,    96,    97,    98,    -1,
       1,    -1,    -1,   103,    -1,    -1,    -1,    -1,   108,    -1,
      -1,    12,    13,   113,    15,    -1,   116,    -1,    -1,    -1,
     120,    -1,   122,   123,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    98,    99,   100,   101,   102,   103,    -1,    -1,   106,
      -1,    -1,    -1,   110,    -1,    -1,   113,    -1,   115,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    65,    66,    67,    68,    69,    70,
      71,    72,    73,    74,    75,    76,    77,    78,    79,    80,
      81,    82,    83,    84,    -1,    86,    87,    88,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,     0,     1,
      -1,    -1,   103,    -1,    -1,    -1,    -1,   108,    -1,    -1,
      -1,    -1,   113,    -1,    -1,   116,     0,    19,    -1,   120,
      -1,   122,   123,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,     0,     1,    -1,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    19,    -1,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    -1,    -1,    -1,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    -1,    -1,    -1,    -1,    -1,    98,    99,   100,   101,
     102,   103,    -1,    -1,   106,    -1,    -1,   109,    -1,    -1,
     112,   113,    -1,   115,    -1,    -1,    -1,    -1,    -1,    -1,
       0,     1,    -1,    -1,    -1,   109,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    98,    99,   100,   101,   102,   103,    19,
      -1,   106,    -1,    -1,   109,    -1,    -1,   112,   113,    -1,
     115,    -1,    -1,    -1,    -1,    -1,    -1,     0,     1,    -1,
      40,    41,    42,    43,    44,    45,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    19,     0,     1,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    19,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    -1,    -1,     0,     1,    -1,    98,    99,
     100,   101,   102,   103,    -1,    -1,   106,    -1,    -1,   109,
      -1,    -1,   112,   113,    19,   115,    -1,    -1,    -1,    -1,
      -1,    -1,     0,     1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    98,    99,   100,   101,   102,
     103,    19,    -1,   106,    -1,    -1,   109,    -1,    -1,   112,
     113,    -1,   115,    -1,    -1,    98,    99,   100,   101,   102,
     103,     0,     1,   106,    -1,    -1,   109,    -1,    -1,    -1,
     113,    -1,   115,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      19,     1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    98,    99,   100,   101,   102,   103,    19,
      -1,   106,    -1,    -1,    -1,   110,    -1,    -1,   113,    -1,
     115,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      98,    99,   100,   101,   102,   103,    -1,    -1,   106,    -1,
      -1,   109,    -1,    -1,    -1,   113,    -1,   115,    -1,    -1,
      -1,    -1,    -1,    12,    13,    -1,    15,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    98,
      99,   100,   101,   102,   103,    -1,    -1,   106,    -1,    -1,
     109,    -1,    -1,    -1,   113,    -1,   115,    -1,    98,    99,
     100,   101,   102,   103,    -1,    -1,   106,    -1,    57,    -1,
      -1,    -1,    -1,   113,    -1,   115,    65,    66,    67,    68,
      69,    70,    71,    72,    73,    74,    75,    76,    77,    78,
      79,    80,    81,    82,    83,    84,    -1,    86,    87,    88,
      89,    90,    91,    92,    93,    94,    95,    96,    97,    98,
      12,    13,    -1,    15,   103,    -1,    -1,    -1,    -1,   108,
      -1,    -1,    -1,    -1,   113,   114,    -1,   116,    -1,    -1,
     119,   120,    -1,   122,   123,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    65,    66,    67,    68,    69,    70,    71,
      72,    73,    74,    75,    76,    77,    78,    79,    80,    81,
      82,    83,    84,    -1,    86,    87,    88,    89,    90,    91,
      92,    93,    94,    95,    96,    97,    98,    12,    13,    -1,
      15,   103,    -1,    -1,    -1,    -1,   108,    -1,    -1,    -1,
      -1,   113,   114,    -1,   116,    -1,    -1,   119,   120,    -1,
     122,   123,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
      -1,    86,    87,    88,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,     0,     1,    -1,    -1,   103,    -1,
      -1,    -1,    -1,   108,    -1,    -1,    -1,    13,   113,    -1,
      -1,   116,     0,     1,    -1,   120,    -1,   122,   123,    -1,
      -1,    -1,    -1,    -1,    -1,    13,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      -1,    -1,    40,    41,    42,    43,    44,    45,    46,    47,
      48,    49,    50,    51,    52,    53,    54,    55,    -1,    -1,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
       1,    86,    87,    88,    89,    90,    91,    92,    93,    94,
      95,    96,    13,   109,    15,    16,    17,    18,    19,    20,
      21,    22,    23,    24,    25,    26,    -1,    28,    29,    -1,
      -1,   109,    -1,    -1,    -1,    -1,    -1,    38,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,     1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    -1,    28,    29,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    65,    66,    67,    68,    69,    70,    71,    72,
      73,    74,    75,    76,    77,    78,    79,    80,    81,    82,
      83,    -1,    -1,    86,    87,    88,    89,    90,    91,    92,
      93,    94,    95,    96,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     113,    -1,    -1,   116,    -1,    -1,    -1,   120,    65,    66,
      67,    68,    69,    70,    71,    72,    73,    74,    75,    76,
      77,    78,    79,    80,    81,    82,    83,    -1,    -1,    86,
      87,    88,    89,    90,    91,    92,    93,    94,    95,    96
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_int16 yystos[] =
{
       0,    27,    30,    31,    32,    33,    34,    35,    36,   125,
     126,   127,   128,   129,   130,   131,   132,   140,     1,     5,
     133,   134,   251,   252,   134,   206,   134,   134,   134,   134,
     134,   134,     0,   135,   262,     5,    12,   257,     1,   230,
     231,   232,   233,   262,   263,    24,    28,   142,   150,   151,
     152,   153,   169,   170,   172,   173,   181,   182,   183,   184,
     192,   193,   199,   200,   201,   202,   207,   210,    13,    15,
      16,    17,    18,    19,    20,    21,   212,   213,   214,   215,
     217,   218,   219,   220,   224,   228,    12,    13,    15,    65,
      66,    67,    68,    69,    70,    71,    72,    73,    74,    75,
      76,    77,    78,    79,    80,    81,    82,    83,    84,    86,
      87,    88,    89,    90,    91,    92,    93,    94,    95,    96,
      97,    98,   103,   108,   113,   116,   120,   122,   123,   205,
     236,   237,   241,   242,   243,   249,    13,   188,   189,   190,
     204,   205,   189,     5,     6,   141,   265,   134,   253,   257,
     262,     0,   232,   112,     1,    17,    13,     1,    58,    59,
     113,   157,   158,   160,   161,   162,   163,   164,   165,   134,
     134,   134,    22,    12,    97,   155,   163,    25,    38,    39,
      13,    12,    13,   185,    23,    26,    29,   212,    21,    17,
      98,    99,   101,   106,   107,   262,    13,     1,   134,   229,
      21,     0,   209,     5,   116,   117,   118,   119,   203,    13,
      20,   217,   218,   218,   219,   134,   134,   134,   134,   134,
     134,   134,   134,   134,   134,   134,    84,   242,   134,     0,
     114,   119,   239,   240,   241,   134,   134,   134,   134,   114,
     115,   134,    86,     0,   143,   144,     1,    19,    98,    99,
     100,   101,   102,   103,   106,   113,   259,   260,   261,     0,
     112,   139,   115,   139,   258,   264,   112,   134,   262,   134,
     134,   262,   134,   134,     1,   134,   134,    13,   171,     1,
     114,     0,   162,   167,    13,   154,     0,   134,   134,   115,
     134,   134,   134,   134,   168,   168,   134,   168,   168,   209,
     100,   262,   134,   229,   134,   229,   134,   229,   134,   229,
     134,   229,    13,   262,    13,    20,   214,   221,     0,   111,
     138,   114,   215,   134,   134,   134,    13,   215,   218,     0,
       1,   110,   137,   237,   238,   113,   205,   238,   242,   244,
     247,   248,    13,   137,   235,   238,   134,   134,   134,   134,
     239,   241,     0,   134,   134,     1,    28,   142,   151,   169,
     173,   182,   183,   192,   199,   201,   254,   255,   262,   135,
     264,   264,   264,     1,   258,   259,   260,   134,   264,   262,
     265,   264,    13,    60,   134,   159,   262,   134,   114,   134,
     155,   263,   208,    62,   113,   175,   176,   177,   178,   179,
     180,   115,   115,    13,    17,   194,   227,   115,   115,   208,
     134,   229,    13,    13,    14,   204,   137,   215,   216,   137,
     215,   137,   216,   137,   216,   137,   264,   134,    13,   221,
       7,     8,     9,    10,    11,   121,   138,   225,   134,   119,
     262,   137,   137,   134,   242,   137,     5,   133,   245,   246,
     134,    13,   137,   137,   241,   190,   230,   262,   252,   252,
     163,    25,   252,   252,    23,    26,    29,   257,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,   198,   250,   138,   137,     0,
     109,   136,     1,   237,   137,   134,   134,    60,   265,   263,
     134,   134,   163,   166,   134,     1,   134,   174,    63,    64,
      63,    64,   166,   166,   134,   227,    13,   208,   134,   166,
     166,   115,   216,   137,   134,   134,    88,   134,   134,   134,
     134,   138,   225,   134,   211,   134,   264,   238,   248,   116,
     120,   244,   247,    20,   119,   137,   134,   134,   136,   265,
     112,     1,   252,   252,   252,   112,   258,   252,   264,    57,
     234,    17,   156,   157,   134,   263,   139,   139,   258,   134,
     179,   262,    13,   175,   115,   134,   134,   134,   134,   134,
     134,   134,   115,   206,   206,   166,   134,   137,   137,   134,
     114,   137,   137,   137,   137,   134,    12,    13,   226,   213,
     137,   246,   133,   133,   134,   134,   257,   262,   134,     1,
     134,   137,   158,   145,   146,   264,   134,   137,   166,   179,
     179,   179,   179,   263,   263,   166,   230,   230,   206,   137,
     137,   134,   226,   134,   137,   258,   265,   264,   237,   134,
     136,   143,   147,   149,   137,    17,   134,   134,   186,   187,
     186,   206,   136,   136,   230,   215,   134,    13,   222,   223,
       1,   148,   151,   153,   169,   170,   172,   184,   193,   200,
     202,   210,   254,   255,   256,   135,   134,   134,   145,   136,
       1,   188,   191,   136,   195,   230,   136,   223,   134,   138,
     262,   163,   257,     1,   237,   136,   265,   134,   258,   136,
     196,   198,   138,   265,   264,   234,   263,   134,   134,   197,
     257,   137,   137,   263,   230,   134,   134,   134,   115,   134,
     230,   136
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_int16 yyr1[] =
{
       0,   124,   125,   125,   125,   125,   125,   125,   125,   125,
     126,   127,   128,   129,   130,   131,   132,   133,   133,   134,
     134,   135,   135,   135,   136,   136,   137,   137,   138,   138,
     139,   139,   140,   140,   140,   141,   141,   142,   142,   142,
     142,   142,   142,   142,   142,   142,   143,   144,   144,   145,
     145,   146,   146,   147,   148,   148,   148,   148,   148,   148,
     148,   148,   149,   149,   150,   151,   152,   152,   153,   154,
     154,   155,   155,   156,   156,   157,   157,   158,   158,   159,
     159,   160,   160,   160,   161,   161,   162,   162,   162,   163,
     163,   164,   164,   164,   165,   165,   166,   167,   168,   169,
     170,   171,   172,   173,   174,   175,   175,   175,   175,   176,
     177,   177,   178,   178,   179,   179,   179,   180,   180,   181,
     182,   183,   184,   184,   185,   185,   186,   186,   187,   187,
     187,   188,   189,   189,   190,   190,   191,   192,   193,   194,
     194,   194,   194,   195,   195,   197,   196,   198,   198,   198,
     198,   198,   198,   198,   198,   198,   198,   198,   198,   198,
     198,   198,   198,   199,   200,   201,   202,   203,   203,   203,
     203,   204,   204,   205,   205,   206,   207,   208,   209,   210,
     211,   212,   212,   213,   213,   213,   213,   214,   214,   214,
     215,   215,   215,   215,   215,   215,   216,   216,   217,   217,
     218,   218,   219,   219,   219,   219,   219,   220,   221,   222,
     223,   223,   224,   224,   224,   224,   224,   225,   225,   225,
     225,   225,   225,   226,   226,   227,   228,   228,   228,   228,
     228,   228,   228,   228,   228,   228,   228,   228,   228,   228,
     228,   228,   229,   230,   230,   230,   230,   231,   231,   232,
     232,   232,   232,   232,   233,   234,   234,   235,   235,   236,
     236,   236,   237,   237,   237,   237,   238,   239,   240,   240,
     241,   241,   241,   241,   241,   241,   241,   241,   241,   241,
     241,   241,   241,   241,   242,   242,   242,   242,   242,   242,
     242,   242,   242,   242,   242,   242,   242,   242,   242,   242,
     242,   242,   242,   242,   242,   242,   242,   242,   242,   242,
     242,   242,   242,   242,   243,   243,   243,   244,   244,   245,
     245,   245,   245,   246,   246,   247,   247,   248,   248,   248,
     248,   249,   249,   250,   250,   251,   252,   253,   253,   254,
     254,   254,   254,   254,   254,   254,   254,   254,   255,   255,
     255,   255,   256,   256,   256,   257,   258,   259,   260,   261,
     261,   261,   261,   261,   261,   261,   261,   262,   263,   264,
     264,   264,   264,   264,   265,   265,   265,   265
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     3,     1,     1,     1,     1,     1,     1,     1,
       5,     5,     4,     4,     4,     4,     5,     1,     2,     0,
       1,     0,     2,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     0,     5,     2,     0,     3,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     0,     2,     2,     1,
       2,     0,     3,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     2,     2,     0,     3,     6,     6,     6,     0,
       2,     1,     1,     0,     3,     6,     4,     1,     5,     1,
       5,     0,     2,     2,     2,     3,     1,     4,     3,     0,
       1,     1,     2,     1,     4,     5,     0,     0,     1,     3,
       8,     1,    10,     0,     0,     1,     1,     1,     1,     3,
       4,     4,     4,     4,     5,     1,     6,    10,    10,     0,
       3,     3,     9,     9,     1,     1,     1,     2,     0,     4,
       5,     5,     2,     5,     2,     1,     2,     0,    10,     2,
       3,     2,     0,     1,     4,     0,     7,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     0,     8,     0,     8,     2,     2,     2,
       4,     1,     0,     1,     1,     1,     0,     0,     0,     9,
       0,     1,     6,     1,     2,     3,     3,     1,     2,     2,
       1,     2,     1,     2,     3,     2,     1,     5,     1,     1,
       1,     2,     1,     1,     1,     1,     1,     2,     2,     2,
       1,     0,     4,     9,     5,    10,     3,     1,     1,     1,
       1,     1,     1,     1,     1,     2,     3,     4,     7,     5,
       6,     4,     6,     7,     6,     4,     6,     4,     6,     4,
       6,     4,     3,     0,     1,     2,     1,     3,     4,     6,
       8,     6,     4,     3,     3,     2,     0,     2,     3,     3,
       4,     4,     1,     3,     2,     4,     3,     2,     1,     2,
       2,     3,     2,     2,     2,     3,     2,     2,     2,     2,
       2,     2,     2,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     4,     3,     4,     1,     2,     3,
       3,     3,     3,     0,     1,     5,     4,     1,     3,     3,
       1,     5,     4,     1,     1,     3,     3,     2,     2,     2,
       2,     3,     3,     5,     3,     2,     2,     3,     5,     3,
       3,     3,     4,     2,     2,     0,     3,     3,     3,     1,
       1,     1,     1,     1,     1,     1,     1,     0,     0,     0,
       2,     2,     2,     2,     0,     2,     2,     2
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (&yylloc, scanner, parser, YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)                                \
    do                                                                  \
      if (N)                                                            \
        {                                                               \
          (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;        \
          (Current).first_column = YYRHSLOC (Rhs, 1).first_column;      \
          (Current).last_line    = YYRHSLOC (Rhs, N).last_line;         \
          (Current).last_column  = YYRHSLOC (Rhs, N).last_column;       \
        }                                                               \
      else                                                              \
        {                                                               \
          (Current).first_line   = (Current).last_line   =              \
            YYRHSLOC (Rhs, 0).last_line;                                \
          (Current).first_column = (Current).last_column =              \
            YYRHSLOC (Rhs, 0).last_column;                              \
        }                                                               \
    while (0)
#endif

#define YYRHSLOC(Rhs, K) ((Rhs)[K])


/* Enable debugging if requested.  */
#if KATANADEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if defined KATANALTYPE_IS_TRIVIAL && KATANALTYPE_IS_TRIVIAL

/* Print *YYLOCP on YYO.  Private, do not rely on its existence. */

YY_ATTRIBUTE_UNUSED
static int
yy_location_print_ (FILE *yyo, YYLTYPE const * const yylocp)
{
  int res = 0;
  int end_col = 0 != yylocp->last_column ? yylocp->last_column - 1 : 0;
  if (0 <= yylocp->first_line)
    {
      res += YYFPRINTF (yyo, "%d", yylocp->first_line);
      if (0 <= yylocp->first_column)
        res += YYFPRINTF (yyo, ".%d", yylocp->first_column);
    }
  if (0 <= yylocp->last_line)
    {
      if (yylocp->first_line < yylocp->last_line)
        {
          res += YYFPRINTF (yyo, "-%d", yylocp->last_line);
          if (0 <= end_col)
            res += YYFPRINTF (yyo, ".%d", end_col);
        }
      else if (0 <= end_col && yylocp->first_column < end_col)
        res += YYFPRINTF (yyo, "-%d", end_col);
    }
  return res;
 }

#  define YY_LOCATION_PRINT(File, Loc)          \
  yy_location_print_ (File, &(Loc))

# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value, Location, scanner, parser); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp, void* scanner, struct KatanaInternalParser * parser)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  YYUSE (yylocationp);
  YYUSE (scanner);
  YYUSE (parser);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yytype], *yyvaluep);
# endif
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp, void* scanner, struct KatanaInternalParser * parser)
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  YY_LOCATION_PRINT (yyo, *yylocationp);
  YYFPRINTF (yyo, ": ");
  yy_symbol_value_print (yyo, yytype, yyvaluep, yylocationp, scanner, parser);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp, YYLTYPE *yylsp, int yyrule, void* scanner, struct KatanaInternalParser * parser)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[+yyssp[yyi + 1 - yynrhs]],
                       &yyvsp[(yyi + 1) - (yynrhs)]
                       , &(yylsp[(yyi + 1) - (yynrhs)])                       , scanner, parser);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, yylsp, Rule, scanner, parser); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !KATANADEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !KATANADEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
#  else
/* Return the length of YYSTR.  */
static YYPTRDIFF_T
yystrlen (const char *yystr)
{
  YYPTRDIFF_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYPTRDIFF_T *yymsg_alloc, char **yymsg,
                yy_state_t *yyssp, int yytoken)
{
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat: reported tokens (one for the "unexpected",
     one per "expected"). */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Actual size of YYARG. */
  int yycount = 0;
  /* Cumulated lengths of YYARG.  */
  YYPTRDIFF_T yysize = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[+*yyssp];
      YYPTRDIFF_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
      yysize = yysize0;
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYPTRDIFF_T yysize1
                    = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
                    yysize = yysize1;
                  else
                    return 2;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    /* Don't count the "%s"s in the final size, but reserve room for
       the terminator.  */
    YYPTRDIFF_T yysize1 = yysize + (yystrlen (yyformat) - 2 * yycount) + 1;
    if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
      yysize = yysize1;
    else
      return 2;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          ++yyp;
          ++yyformat;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, YYLTYPE *yylocationp, void* scanner, struct KatanaInternalParser * parser)
{
  YYUSE (yyvaluep);
  YYUSE (yylocationp);
  YYUSE (scanner);
  YYUSE (parser);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/*----------.
| yyparse.  |
`----------*/

int
yyparse (void* scanner, struct KatanaInternalParser * parser)
{
/* The lookahead symbol.  */
int yychar;


/* The semantic value of the lookahead symbol.  */
/* Default value used for initialization, for pacifying older GCCs
   or non-GCC compilers.  */
YY_INITIAL_VALUE (static YYSTYPE yyval_default;)
YYSTYPE yylval YY_INITIAL_VALUE (= yyval_default);

/* Location data for the lookahead symbol.  */
static YYLTYPE yyloc_default
# if defined KATANALTYPE_IS_TRIVIAL && KATANALTYPE_IS_TRIVIAL
  = { 1, 1, 1, 1 }
# endif
;
YYLTYPE yylloc = yyloc_default;

    /* Number of syntax errors so far.  */
    int yynerrs;

    yy_state_fast_t yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.
       'yyls': related to locations.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss;
    yy_state_t *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    /* The location stack.  */
    YYLTYPE yylsa[YYINITDEPTH];
    YYLTYPE *yyls;
    YYLTYPE *yylsp;

    /* The locations where the error started and ended.  */
    YYLTYPE yyerror_range[3];

    YYPTRDIFF_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;
  YYLTYPE yyloc;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYPTRDIFF_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N), yylsp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yylsp = yyls = yylsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  yylsp[0] = yylloc;
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;
        YYLTYPE *yyls1 = yyls;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yyls1, yysize * YYSIZEOF (*yylsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
        yyls = yyls1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
        YYSTACK_RELOCATE (yyls_alloc, yyls);
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;
      yylsp = yyls + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex (&yylval, &yylloc, scanner, parser);
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END
  *++yylsp = yylloc;

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];

  /* Default location. */
  YYLLOC_DEFAULT (yyloc, (yylsp - yylen), yylen);
  yyerror_range[1] = yyloc;
  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 10:
                                                                          {
        katana_parse_internal_rule(parser, (yyvsp[-2].rule));
    }
    break;

  case 11:
                                                                                      {
        katana_parse_internal_keyframe_rule(parser, (yyvsp[-2].keyframe));
    }
    break;

  case 12:
                                                                         {
        katana_parse_internal_keyframe_key_list(parser, (yyvsp[-1].valueList));
    }
    break;

  case 13:
                                                                                        {
        /* can be empty */
        katana_parse_internal_declaration_list(parser, (yyvsp[-1].boolean));
    }
    break;

  case 14:
                                                         {
        katana_parse_internal_value(parser, (yyvsp[-1].valueList));
    }
    break;

  case 15:
                                                                     {
        katana_parse_internal_selector(parser, (yyvsp[-1].selectorList));
    }
    break;

  case 16:
                                                                                        {
        katana_parse_internal_media_list(parser, (yyvsp[-1].mediaList));
    }
    break;

  case 33:
  {
      /* create a charset rule and push to stylesheet rules */
      katana_set_charset(parser, &(yyvsp[-2].string));
  }
    break;

  case 36:
                             {
     if ((yyvsp[-1].rule))
         katana_add_rule(parser, (yyvsp[-1].rule));
 }
    break;

  case 46:
                {
      katana_start_rule(parser);
    }
    break;

  case 47:
                           {
        (yyval.rule) = (yyvsp[0].rule);
        // parser->m_hadSyntacticallyValidCSSRule = true;
        katana_end_rule(parser, !!(yyval.rule));
    }
    break;

  case 48:
                             {
        (yyval.rule) = 0;
        katana_end_rule(parser, false);
    }
    break;

  case 51:
                { (yyval.ruleList) = 0; }
    break;

  case 52:
                                          {
      (yyval.ruleList) = katana_rule_list_add(parser, (yyvsp[-1].rule), (yyvsp[-2].ruleList));
    }
    break;

  case 53:
                                    {
        katana_end_rule(parser, false);
    }
    break;

  case 62:
                                 {
        (yyval.rule) = (yyvsp[0].rule);
        katana_end_rule(parser, !!(yyval.rule));
    }
    break;

  case 63:
                             {
        (yyval.rule) = 0;
        katana_end_rule(parser, false);
    }
    break;

  case 64:
                {
      katana_start_rule_header(parser, KatanaRuleImport);
    }
    break;

  case 65:
                                                         {
        katana_end_rule_header(parser);
        katana_start_rule_body(parser);
    }
    break;

  case 66:
                                                                                            {
        (yyval.rule) = katana_new_import_rule(parser, &(yyvsp[-4].string), (yyvsp[-1].mediaList));
    }
    break;

  case 67:
                                                                                              {
        (yyval.rule) = 0;
    }
    break;

  case 68:
                                                                                               {
        (yyval.rule) = katana_new_namespace_rule(parser, &(yyvsp[-3].string), &(yyvsp[-2].string));
    }
    break;

  case 69:
            { (yyval.string) = (KatanaParserString){"", 0}; }
    break;

  case 73:
              {
        (yyval.valueList) = 0;
    }
    break;

  case 74:
                           {
        (yyval.valueList) = (yyvsp[0].valueList);
    }
    break;

  case 75:
                                                                                       {
        katana_string_to_lowercase(parser, &(yyvsp[-3].string));
        (yyval.mediaQueryExp) = katana_new_media_query_exp(parser, &(yyvsp[-3].string), (yyvsp[-1].valueList));
        if (!(yyval.mediaQueryExp))
            YYERROR;
    }
    break;

  case 76:
                                                   {
        YYERROR;
    }
    break;

  case 77:
                    {
        (yyval.mediaQueryExpList) = katana_new_media_query_exp_list(parser);
        katana_media_query_exp_list_add(parser, (yyvsp[0].mediaQueryExp), (yyval.mediaQueryExpList));   
    }
    break;

  case 78:
                                                                                        {
        (yyval.mediaQueryExpList) = (yyvsp[-4].mediaQueryExpList);
        katana_media_query_exp_list_add(parser, (yyvsp[0].mediaQueryExp), (yyval.mediaQueryExpList));   
    }
    break;

  case 79:
                {
        (yyval.mediaQueryExpList) = katana_new_media_query_exp_list(parser);
    }
    break;

  case 80:
                                                                                    {
        (yyval.mediaQueryExpList) = (yyvsp[-1].mediaQueryExpList);
    }
    break;

  case 81:
              {
        (yyval.mediaQueryRestrictor) = KatanaMediaQueryRestrictorNone;
    }
    break;

  case 82:
                                        {
        (yyval.mediaQueryRestrictor) = KatanaMediaQueryRestrictorOnly;
    }
    break;

  case 83:
                                       {
        (yyval.mediaQueryRestrictor) = KatanaMediaQueryRestrictorNot;
    }
    break;

  case 84:
                                     {
        (yyval.mediaQuery) = katana_new_media_query(parser, KatanaMediaQueryRestrictorNone, NULL, (yyvsp[-1].mediaQueryExpList));
    }
    break;

  case 85:
                                                                   {
        katana_string_to_lowercase(parser, &(yyvsp[-1].string));
        (yyval.mediaQuery) = katana_new_media_query(parser, (yyvsp[-2].mediaQueryRestrictor), &(yyvsp[-1].string), (yyvsp[0].mediaQueryExpList));
    }
    break;

  case 87:
                                                                 {
        katana_parser_report_error(parser, (yyvsp[-1].location), "parser->lastLocationLabel(), InvalidMediaQueryCSSError");
        (yyval.mediaQuery) = katana_new_media_query(parser, KatanaMediaQueryRestrictorNot, NULL, NULL);
    }
    break;

  case 88:
                                               {
        katana_parser_report_error(parser, (yyvsp[-1].location), "parser->lastLocationLabel(), InvalidMediaQueryCSSError");
        (yyval.mediaQuery) = katana_new_media_query(parser, KatanaMediaQueryRestrictorNot, NULL, NULL);
    }
    break;

  case 89:
                {
        (yyval.mediaList) = katana_new_media_list(parser);
    }
    break;

  case 91:
                {
        (yyval.mediaList) =  katana_new_media_list(parser);
        katana_media_list_add(parser, (yyvsp[0].mediaQuery), (yyval.mediaList));
    }
    break;

  case 92:
                          {
        (yyval.mediaList) = (yyvsp[-1].mediaList);
        katana_media_list_add(parser, (yyvsp[0].mediaQuery), (yyval.mediaList));
    }
    break;

  case 93:
              {
        (yyval.mediaList) = (yyvsp[0].mediaList);
        // $$->addMediaQuery(parser->sinkFloatingMediaQuery(parser->createFloatingNotAllQuery()));
        katana_parser_log(parser, "createFloatingNotAllQuery");
    }
    break;

  case 94:
                                               {
        (yyval.mediaList) = katana_new_media_list(parser);
        katana_media_list_add(parser, (yyvsp[-3].mediaQuery), (yyval.mediaList));
    }
    break;

  case 95:
                                                         {
        (yyval.mediaList) = (yyvsp[-4].mediaList);
        katana_media_list_add(parser, (yyvsp[-3].mediaQuery), (yyval.mediaList));
    }
    break;

  case 96:
                {
        katana_start_rule_body(parser);
    }
    break;

  case 97:
                {
      katana_start_rule_header(parser, KatanaRuleMedia);
    }
    break;

  case 98:
                {
        katana_end_rule_header(parser);
    }
    break;

  case 100:
                                                                                                                          {
        (yyval.rule) = katana_new_media_rule(parser, (yyvsp[-6].mediaList), (yyvsp[-1].ruleList));
    }
    break;

  case 102:
                                                                                                                                                                             {
        // $$ = parser->createSupportsRule($4, $9);
    }
    break;

  case 103:
                {
        // parser->startRuleHeader(StyleRule::Supports);
        // parser->markSupportsRuleHeaderStart();
    }
    break;

  case 104:
                {
        // parser->endRuleHeader();
        // parser->markSupportsRuleHeaderEnd();
    }
    break;

  case 109:
                                                                     {
        // $$ = !$3;
    }
    break;

  case 110:
                                                                                                  {
        // $$ = $1 && $4;
    }
    break;

  case 111:
                                                                                            {
        // $$ = $1 && $4;
    }
    break;

  case 112:
                                                                                                 {
        // $$ = $1 || $4;
    }
    break;

  case 113:
                                                                                           {
        // $$ = $1 || $4;
    }
    break;

  case 114:
                                                                       {
        // $$ = $3;
    }
    break;

  case 116:
                                                                              {
        // parser->reportError($3, InvalidSupportsConditionCSSError);
        // $$ = false;
    }
    break;

  case 117:
                                                                                                           {
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
    }
    break;

  case 118:
                                                                                                                        {
        // $$ = false;
        // parser->endProperty(false, false, GeneralCSSError);        
    }
    break;

  case 119:
                {
      katana_start_rule_header(parser, KatanaRuleKeyframes);
    }
    break;

  case 120:
    {
      (yyval.boolean) = false;
    }
    break;

  case 122:
                                                                                   {
        (yyval.rule) = katana_new_keyframes_rule(parser, &(yyvsp[-7].string), (yyvsp[-1].keyframeRuleList), (yyvsp[-8].boolean));
    }
    break;

  case 123:
                                                                                   {
        (yyval.rule) = katana_new_keyframes_rule(parser, &(yyvsp[-7].string), (yyvsp[-1].keyframeRuleList), true);
    }
    break;

  case 125:
                        {
        // if (parser->m_context.useCounter())
        //    parser->m_context.useCounter()->count(UseCounter::QuotedKeyframesRule);
    }
    break;

  case 127:
                                                  {
        katana_parser_clear_declarations(parser);
        katana_parser_reset_declarations(parser);
    }
    break;

  case 128:
                {
        (yyval.keyframeRuleList) = katana_new_Keyframe_list(parser);
        katana_parser_resume_error_logging();
    }
    break;

  case 129:
                                                                   {
        (yyval.keyframeRuleList) = (yyvsp[-3].keyframeRuleList);
        katana_keyframe_rule_list_add(parser, (yyvsp[-2].keyframe), (yyval.keyframeRuleList));
    }
    break;

  case 130:
                                                                                           {
        katana_parser_clear_declarations(parser);
        katana_parser_reset_declarations(parser);
        katana_parser_resume_error_logging();
    }
    break;

  case 131:
                                                            {
        (yyval.keyframe) = katana_new_keyframe(parser, (yyvsp[-4].valueList));
    }
    break;

  case 132:
                    {
        (yyval.valueList) = katana_new_value_list(parser);
        katana_value_list_add(parser, (yyvsp[-1].value), (yyval.valueList));
    }
    break;

  case 133:
                                               {
        (yyval.valueList) = (yyvsp[-4].valueList);
        katana_value_list_add(parser, (yyvsp[-1].value), (yyval.valueList));
    }
    break;

  case 134:
                                               {
        (yyval.value) = katana_new_number_value(parser, (yyvsp[-1].integer), &(yyvsp[0].number), KATANA_VALUE_NUMBER);
    }
    break;

  case 135:
                       {
        if (!strcasecmp((yyvsp[0].string).data, "from")) {
            KatanaParserNumber number;
            number.val = 0;
            number.raw = (KatanaParserString){"from", 4};
            (yyval.value) = katana_new_number_value(parser, 1, &number, KATANA_VALUE_NUMBER);
        }
        else if (!strcasecmp((yyvsp[0].string).data, "to")) {
            KatanaParserNumber number;
            number.val = 100;
            number.raw = (KatanaParserString){"to", 4};
            (yyval.value) = katana_new_number_value(parser, 1, &number, KATANA_VALUE_NUMBER);
        }
        else {
            YYERROR;
        }
    }
    break;

  case 136:
                              {
        // katana_parser_report_error(parser, parser->lastLocationLabel(), InvalidKeyframeSelectorCSSError);
        katana_parser_clear_declarations(parser);
        katana_parser_reset_declarations(parser);
        katana_parser_report_error(parser, NULL, "InvalidKeyframeSelectorCSSError");
    }
    break;

  case 137:
                {
      katana_start_rule_header(parser, KatanaRulePage);
        // parser->startRuleHeader(StyleRule::Page);
    }
    break;

  case 138:
                                                                                                 {
        (yyval.rule) = katana_new_page_rule(parser);
        // if ($4)
        //     $$ = parser->createPageRule(parser->sinkFloatingSelector($4));
        // else {
        //    // Clear properties in the invalid @page rule.
        //    parser->clearProperties();
        //    // Also clear margin at-rules here once we fully implement margin at-rules parsing.
        //    $$ = 0;
        // }
    }
    break;

  case 139:
                                 {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match = KatanaSelectorMatchTag;
        (yyval.selector)->tag = katana_new_qualified_name(parser, NULL, &(yyvsp[-1].string), &parser->default_namespace);

        // $$ = parser->createFloatingSelectorWithTagName(QualifiedName(nullAtom, $1, parser->m_defaultNamespace));
        // $$->setForPage();
    }
    break;

  case 140:
                                               {
        // $$ = $2;
        // $$->prependTagSelector(QualifiedName(nullAtom, $1, parser->m_defaultNamespace));
        // $$->setForPage();
    }
    break;

  case 141:
                              {
        // $$ = $1;
        // $$->setForPage();
    }
    break;

  case 142:
                  {
        // $$ = parser->createFloatingSelector();
        // $$->setForPage();
    }
    break;

  case 145:
               {
        // parser->startDeclarationsForMarginBox();
    }
    break;

  case 146:
                                                                 {
        // $$ = parser->createMarginAtRule($1);
    }
    break;

  case 147:
                      {
        // $$ = CSSSelector::TopLeftCornerMarginBox;
    }
    break;

  case 148:
                  {
        // $$ = CSSSelector::TopLeftMarginBox;
    }
    break;

  case 149:
                    {
        // $$ = CSSSelector::TopCenterMarginBox;
    }
    break;

  case 150:
                   {
        // $$ = CSSSelector::TopRightMarginBox;
    }
    break;

  case 151:
                         {
        // $$ = CSSSelector::TopRightCornerMarginBox;
    }
    break;

  case 152:
                           {
        // $$ = CSSSelector::BottomLeftCornerMarginBox;
    }
    break;

  case 153:
                     {
        // $$ = CSSSelector::BottomLeftMarginBox;
    }
    break;

  case 154:
                       {
        // $$ = CSSSelector::BottomCenterMarginBox;
    }
    break;

  case 155:
                      {
        // $$ = CSSSelector::BottomRightMarginBox;
    }
    break;

  case 156:
                            {
        // $$ = CSSSelector::BottomRightCornerMarginBox;
    }
    break;

  case 157:
                  {
        // $$ = CSSSelector::LeftTopMarginBox;
    }
    break;

  case 158:
                     {
        // $$ = CSSSelector::LeftMiddleMarginBox;
    }
    break;

  case 159:
                     {
        // $$ = CSSSelector::LeftBottomMarginBox;
    }
    break;

  case 160:
                   {
        // $$ = CSSSelector::RightTopMarginBox;
    }
    break;

  case 161:
                      {
        // $$ = CSSSelector::RightMiddleMarginBox;
    }
    break;

  case 162:
                      {
        // $$ = CSSSelector::RightBottomMarginBox;
    }
    break;

  case 163:
                {
        katana_start_rule_header(parser, KatanaRuleFontFace);
    }
    break;

  case 164:
                                                                                         {
        (yyval.rule) = katana_new_font_face(parser);
    }
    break;

  case 165:
                {
        // parser->markViewportRuleBodyStart();
        // parser->startRuleHeader(StyleRule::Viewport);
    }
    break;

  case 166:
                                                                                         {
        // $$ = parser->createViewportRule();
        // parser->markViewportRuleBodyEnd();
    }
    break;

  case 167:
                    { (yyval.relation) = KatanaSelectorRelationDirectAdjacent; }
    break;

  case 168:
                      { (yyval.relation) = KatanaSelectorRelationIndirectAdjacent; }
    break;

  case 169:
                      { (yyval.relation) = KatanaSelectorRelationChild; }
    break;

  case 170:
                                           {
        if (!strcasecmp((yyvsp[-2].string).data, "deep"))
            (yyval.relation) = KatanaSelectorRelationShadowDeep;
        else
            YYERROR;
    }
    break;

  case 172:
                  { (yyval.integer) = 1; }
    break;

  case 173:
        { (yyval.integer) = -1; }
    break;

  case 174:
        { (yyval.integer) = 1; }
    break;

  case 175:
                {
        katana_start_declaration(parser);
    }
    break;

  case 176:
                {
        katana_start_rule_header(parser, KatanaRuleStyle);
        katana_start_selector(parser);
    }
    break;

  case 177:
                {
        katana_end_rule_header(parser);
    }
    break;

  case 178:
                {
        katana_end_selector(parser);
    }
    break;

  case 179:
                                                                                                                                                               {
        (yyval.rule) = katana_new_style_rule(parser, (yyvsp[-7].selectorList));
    }
    break;

  case 180:
                {
        katana_start_selector(parser);
    }
    break;

  case 181:
                                   {
        (yyval.selectorList) = katana_reusable_selector_list(parser);
        katana_selector_list_shink(parser, 0, (yyval.selectorList));
        katana_selector_list_add(parser, katana_sink_floating_selector(parser, (yyvsp[0].selector)), (yyval.selectorList));
    }
    break;

  case 182:
                                                                                                              {
        (yyval.selectorList) = (yyvsp[-5].selectorList);
        katana_selector_list_add(parser, katana_sink_floating_selector(parser, (yyvsp[0].selector)), (yyval.selectorList));
    }
    break;

  case 185:
    {
        (yyval.selector) = (yyvsp[0].selector);        
        KatanaSelector * end = (yyval.selector);
        if ( NULL != end ) {
            while (NULL != end->tagHistory)
                end = end->tagHistory;
            end->relation = KatanaSelectorRelationDescendant;
            // if ($1->isContentPseudoElement())
            //     end->setRelationIsAffectedByPseudoContent();
            end->tagHistory = katana_sink_floating_selector(parser, (yyvsp[-2].selector));
        }
    }
    break;

  case 186:
                                          {
        (yyval.selector) = (yyvsp[0].selector);
        KatanaSelector * end = (yyval.selector);
        if ( NULL != end ) {
            while (NULL != end->tagHistory)
                end = end->tagHistory;
            end->relation = (yyvsp[-1].relation);
            // if ($1->isContentPseudoElement())
            //     end->setRelationIsAffectedByPseudoContent();
            end->tagHistory = katana_sink_floating_selector(parser, (yyvsp[-2].selector));
        }
    }
    break;

  case 187:
    { 
      katana_string_clear(parser,&(yyval.string)); 
    }
    break;

  case 188:
    { 
      (yyval.string) = kKatanaAsteriskString; 
    }
    break;

  case 189:
    {
      // namespace
      // printf("NS 1:%s\n",katana_string_to_characters(parser,&$1));
      // $$ = $1;
    }
    break;

  case 190:
                 {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match = KatanaSelectorMatchTag;
        (yyval.selector)->tag = katana_new_qualified_name(parser, NULL, &(yyvsp[0].string), &parser->default_namespace);
    }
    break;

  case 191:
                                  {
        (yyval.selector) = katana_rewrite_specifier_with_element_name(parser, &(yyvsp[-1].string), (yyvsp[0].selector));
        if (!(yyval.selector))
            YYERROR;
    }
    break;

  case 192:
                     {
        (yyval.selector) = katana_rewrite_specifier_with_namespace_if_needed(parser, (yyvsp[0].selector));
        if (!(yyval.selector))
            YYERROR;
    }
    break;

  case 193:
                                      {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match = KatanaSelectorMatchTag;
        (yyval.selector)->tag = katana_new_qualified_name(parser, &(yyvsp[-1].string), &(yyvsp[0].string), &(yyvsp[-1].string));
        // $$ = parser->createFloatingSelectorWithTagName(parser->determineNameInNamespace($1, $2));
        // if (!$$)
        //    YYERROR;
    }
    break;

  case 194:
                                                     {
        // printf("namespace_selector element_name specifier_list\n");
        // $$ = parser->rewriteSpecifiersWithElementName($1, $2, $3);
        // if (!$$)
        //    YYERROR;
    }
    break;

  case 195:
                                        {
        // printf("namespace_selector specifier_list\n");
        // $$ = parser->rewriteSpecifiersWithElementName($1, starAtom, $2);
        // if (!$$)
        //    YYERROR;
    }
    break;

  case 196:
                                          {
        // $$ = parser->createFloatingSelectorVector();
        // $$->append(parser->sinkFloatingSelector($1));
    }
    break;

  case 197:
                                                                                             {
        // $$ = $1;
        // $$->append(parser->sinkFloatingSelector($5));
    }
    break;

  case 198:
                     {
        // FIXME: 标签名是否区分大写
        // if (parser->m_context.isHTMLDocument())
        //     parser->tokenToLowerCase($1);
        (yyval.string) = (yyvsp[0].string);
    }
    break;

  case 199:
          {
        (yyval.string) = kKatanaAsteriskString;
    }
    break;

  case 201:
                               {
        (yyval.selector) = katana_rewrite_specifiers(parser, (yyvsp[-1].selector), (yyvsp[0].selector));
    }
    break;

  case 202:
                     {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match =KatanaSelectorMatchId;
        // if (isQuirksModeBehavior(parser->m_context.mode()))
            // parser->tokenToLowerCase($1);
        katana_selector_set_value(parser, (yyval.selector), &(yyvsp[0].string));
    }
    break;

  case 203:
                   {
        if ((yyvsp[0].string).data[0] >= '0' && (yyvsp[0].string).data[0] <= '9') {
            YYERROR;
        } else {
            (yyval.selector) = katana_new_selector(parser);
            (yyval.selector)->match =KatanaSelectorMatchId;
            // if (isQuirksModeBehavior(parser->m_context.mode()))
                // parser->tokenToLowerCase($1);
            katana_selector_set_value(parser, (yyval.selector), &(yyvsp[0].string));
        }
    }
    break;

  case 207:
                         {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match = KatanaSelectorMatchClass;
        // if (isQuirksModeBehavior(parser->m_context.mode()))
        //     parser->tokenToLowerCase($2);
        katana_selector_set_value(parser, (yyval.selector), &(yyvsp[0].string));
    }
    break;

  case 208:
                                 {
        // if (parser->m_context.isHTMLDocument())
        //    parser->tokenToLowerCase($1);
        (yyval.string) = (yyvsp[-1].string);
    }
    break;

  case 209:
                                 {
        KatanaAttributeMatchType attrMatchType = KatanaAttributeMatchTypeCaseSensitive;
        if (!katana_parse_attribute_match_type(parser, attrMatchType, &(yyvsp[-1].string)))
            YYERROR;
        (yyval.attributeMatchType) = attrMatchType;
    }
    break;

  case 211:
                  { (yyval.attributeMatchType) = KatanaAttributeMatchTypeCaseSensitive; }
    break;

  case 212:
                                                     {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->data->attribute = katana_new_qualified_name(parser, NULL, &(yyvsp[-1].string), NULL);
        (yyval.selector)->data->bits.attributeMatchType = KatanaAttributeMatchTypeCaseSensitive;
        (yyval.selector)->match = KatanaSelectorMatchAttributeSet;
    }
    break;

  case 213:
                                                                                                                           {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->data->attribute = katana_new_qualified_name(parser, NULL, &(yyvsp[-6].string), NULL);
        (yyval.selector)->data->bits.attributeMatchType = (yyvsp[-1].attributeMatchType);
        (yyval.selector)->match = (yyvsp[-5].integer);
        katana_selector_set_value(parser, (yyval.selector), &(yyvsp[-3].string));
    }
    break;

  case 214:
                                                                          {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->data->attribute = katana_new_qualified_name(parser, &(yyvsp[-2].string), &(yyvsp[-1].string), NULL);
        (yyval.selector)->data->bits.attributeMatchType = KatanaAttributeMatchTypeCaseSensitive;
        (yyval.selector)->match = KatanaSelectorMatchAttributeSet;
    }
    break;

  case 215:
                                                                                                                                              {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->data->attribute = katana_new_qualified_name(parser, &(yyvsp[-7].string), &(yyvsp[-6].string), NULL);
        (yyval.selector)->data->bits.attributeMatchType = (yyvsp[-1].attributeMatchType);
        (yyval.selector)->match = (yyvsp[-5].integer);
        katana_selector_set_value(parser, (yyval.selector), &(yyvsp[-3].string));
    }
    break;

  case 216:
                                                   {
        YYERROR;
    }
    break;

  case 217:
        {
        (yyval.integer) = KatanaSelectorMatchAttributeExact;
    }
    break;

  case 218:
                          {
        (yyval.integer) = KatanaSelectorMatchAttributeList;
    }
    break;

  case 219:
                           {
        (yyval.integer) = KatanaSelectorMatchAttributeHyphen;
    }
    break;

  case 220:
                            {
        (yyval.integer) = KatanaSelectorMatchAttributeBegin;
    }
    break;

  case 221:
                          {
        (yyval.integer) = KatanaSelectorMatchAttributeEnd;
    }
    break;

  case 222:
                          {
        (yyval.integer) = KatanaSelectorMatchAttributeContain;
    }
    break;

  case 225:
                         {
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
    break;

  case 226:
                                        {

        if (katana_string_is_function(&(yyvsp[0].string)))
            YYERROR;
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match = KatanaSelectorMatchPseudoClass;
        katana_string_to_lowercase(parser, &(yyvsp[0].string));
        katana_selector_set_value(parser, (yyval.selector), &(yyvsp[0].string));
        katana_selector_extract_pseudo_type((yyval.selector));
        // if ($$->pseudo == KatanaSelectorPseudoUnknown) {
        //     katana_parser_report_error(parser, $2, InvalidSelectorPseudoCSSError);
        //     YYERROR;
    }
    break;

  case 227:
                                              {
        if (katana_string_is_function(&(yyvsp[0].string)))
            YYERROR;
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match = KatanaSelectorMatchPseudoElement;
        katana_string_to_lowercase(parser, &(yyvsp[0].string));
        katana_selector_set_value(parser, (yyval.selector), &(yyvsp[0].string));
        katana_selector_extract_pseudo_type((yyval.selector));
        // FIXME: This call is needed to force selector to compute the pseudoType early enough.
        // CSSSelector::PseudoType type = $$->pseudoType();
        // if (type == CSSSelector::PseudoUnknown) {
        //     katana_parser_report_error(parser, $3, InvalidSelectorPseudoCSSError);
        //     YYERROR;
    }
    break;

  case 228:
                                                                                                      {
        // $$ = parser->createFloatingSelector();
        // $$->setMatch(CSSSelector::PseudoElement);
        // $$->adoptSelectorVector(*parser->sinkFloatingSelectorVector($5));
        // $$->setValue($3);
        // CSSSelector::PseudoType type = $$->pseudoType();
        // if (type != CSSSelector::PseudoCue)
        //    YYERROR;
    }
    break;

  case 229:
                                                                           {
        YYERROR;
    }
    break;

  case 230:
                                                                                                  {
        // $$ = parser->createFloatingSelector();
        // $$->setMatch(CSSSelector::PseudoClass);
        // $$->adoptSelectorVector(*parser->sinkFloatingSelectorVector($4));
        // parser->tokenToLowerCase($2);
        // $$->setValue($2);
        // CSSSelector::PseudoType type = $$->pseudoType();
        // if (type != CSSSelector::PseudoAny)
        //    YYERROR;
    }
    break;

  case 231:
                                                                       {
        YYERROR;
    }
    break;

  case 232:
                                                                                         {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match = KatanaSelectorMatchPseudoClass;
        katana_selector_set_argument(parser, (yyval.selector), &(yyvsp[-2].string));
        katana_selector_set_value(parser, (yyval.selector), &(yyvsp[-4].string));
        katana_selector_extract_pseudo_type((yyval.selector));
        // CSSSelector::PseudoType type = $$->pseudoType();
        // if (type == CSSSelector::PseudoUnknown)
        //     YYERROR;
    }
    break;

  case 233:
                                                                                                                  {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match = KatanaSelectorMatchPseudoClass;
        katana_selector_set_argument_with_number(parser, (yyval.selector), (yyvsp[-3].integer), &(yyvsp[-2].number));
        katana_selector_set_value(parser, (yyval.selector), &(yyvsp[-5].string));
        katana_selector_extract_pseudo_type((yyval.selector));
        // $$ = parser->createFloatingSelector();
        // $$->setMatch(CSSSelector::PseudoClass);
        // $$->setArgument(AtomicString::number($4 * $5));
        // $$->setValue($2);
        // CSSSelector::PseudoType type = $$->pseudoType();
        // if (type == CSSSelector::PseudoUnknown)
        //    YYERROR;
    }
    break;

  case 234:
                                                                                           {
        (yyval.selector) = katana_new_selector(parser);
        (yyval.selector)->match = KatanaSelectorMatchPseudoClass;
        katana_selector_set_argument(parser, (yyval.selector), &(yyvsp[-2].string));
        
        katana_string_to_lowercase(parser, &(yyvsp[-4].string));
        katana_selector_set_value(parser, (yyval.selector), &(yyvsp[-4].string));
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
    break;

  case 235:
                                                                    {
        YYERROR;
    }
    break;

  case 236:
                                                                                             {
        if (!katana_selector_is_simple(parser, (yyvsp[-2].selector)))
            YYERROR;
        else {
            (yyval.selector) = katana_new_selector(parser);
            (yyval.selector)->match = KatanaSelectorMatchPseudoClass;
            (yyval.selector)->pseudo = KatanaPseudoNot;

            KatanaArray* array = katana_new_array(parser);
            katana_selector_list_add(parser, katana_sink_floating_selector(parser, (yyvsp[-2].selector)), array);
            katana_adopt_selector_list(parser, array, (yyval.selector));

            katana_string_to_lowercase(parser, &(yyvsp[-4].string));
            katana_selector_set_value(parser, (yyval.selector), &(yyvsp[-4].string));

        }
    }
    break;

  case 237:
                                                                       {
        YYERROR;
    }
    break;

  case 238:
                                                                                                   {
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
    break;

  case 239:
                                                                        {
        YYERROR;
    }
    break;

  case 240:
                                                                                                          {
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
    break;

  case 241:
                                                                               {
        YYERROR;
    }
    break;

  case 243:
                { (yyval.boolean) = false; }
    break;

  case 245:
                            {
        (yyval.boolean) = (yyvsp[-1].boolean) || (yyvsp[0].boolean);
    }
    break;

  case 247:
                                {
        katana_start_declaration(parser);
        (yyval.boolean) = (yyvsp[-2].boolean);
    }
    break;

  case 248:
                                            {
        katana_start_declaration(parser);
        (yyval.boolean) = (yyvsp[-3].boolean) || (yyvsp[-2].boolean);
    }
    break;

  case 249:
                                                      {
        (yyval.boolean) = false;
        bool isPropertyParsed = false;
        // unsigned int oldParsedProperties = parser->parsedProperties->length;
        (yyval.boolean) = katana_new_declaration(parser, &(yyvsp[-5].string), (yyvsp[0].boolean), (yyvsp[-1].valueList));
        if (!(yyval.boolean)) {
            // parser->rollbackLastProperties(parser->m_parsedProperties.size() - oldParsedProperties);
            katana_parser_report_error(parser, (yyvsp[-2].location), "InvalidPropertyValueCSSError");
        } else {
            isPropertyParsed = true;
        }
        katana_end_declaration(parser, (yyvsp[0].boolean), isPropertyParsed);
    }
    break;

  case 250:
                                                                           {
        /* When we encounter something like p {color: red !important fail;} we should drop the declaration */
        katana_parser_report_error(parser, (yyvsp[-4].location), "InvalidPropertyValueCSSError");
        katana_end_declaration(parser, false, false);
        (yyval.boolean) = false;
    }
    break;

  case 251:
                                                                 {
        katana_parser_report_error(parser, (yyvsp[-2].location), "InvalidPropertyValueCSSError");
        katana_end_declaration(parser, false, false);
        (yyval.boolean) = false;
    }
    break;

  case 252:
                                                 {
        katana_parser_report_error(parser, (yyvsp[-1].location), "PropertyDeclarationCSSError");
        katana_end_declaration(parser, false, false);
        (yyval.boolean) = false;
    }
    break;

  case 253:
                                        {
        katana_parser_report_error(parser, (yyvsp[-1].location), "PropertyDeclarationCSSError");
        (yyval.boolean) = false;
    }
    break;

  case 254:
                                                {
        // $$ = cssPropertyID($2);
        // parser->setCurrentProperty($$);
        // if ($$ == CSSPropertyInvalid)
        //    parser->reportError($1, InvalidPropertyCSSError);
        // $$ = $2;
        // katana_set_current_declaration(parser, &$$);

        (yyval.string) = (yyvsp[-1].string);
        katana_set_current_declaration(parser, &(yyval.string));
    }
    break;

  case 255:
                                         { (yyval.boolean) = true; }
    break;

  case 256:
                  { (yyval.boolean) = false; }
    break;

  case 257:
                                 {
        (yyval.valueList) = katana_new_value_list(parser);
        katana_value_list_add(parser, katana_new_ident_value(parser, &(yyvsp[-1].string)), (yyval.valueList));

    }
    break;

  case 258:
                                              {
        (yyval.valueList) = (yyvsp[-2].valueList);
        katana_value_list_add(parser, katana_new_ident_value(parser, &(yyvsp[-1].string)), (yyval.valueList));
    }
    break;

  case 259:
                                        {
        (yyval.value) = katana_new_list_value(parser, NULL);
    }
    break;

  case 260:
                                                     {
        (yyval.value) = katana_new_list_value(parser, (yyvsp[-1].valueList));
    }
    break;

  case 261:
                                                        {
        YYERROR;
    }
    break;

  case 262:
         {
        (yyval.valueList) = katana_new_value_list(parser);
        katana_value_list_add(parser, (yyvsp[0].value), (yyval.valueList));
    }
    break;

  case 263:
                         {
        (yyval.valueList) = (yyvsp[-2].valueList);
        katana_value_list_add(parser, katana_new_operator_value(parser, (yyvsp[-1].character)), (yyval.valueList));
        katana_value_list_add(parser, (yyvsp[0].value), (yyval.valueList)); 
    }
    break;

  case 264:
                {
        (yyval.valueList) = (yyvsp[-1].valueList);
        katana_value_list_add(parser, (yyvsp[0].value), (yyval.valueList));
    }
    break;

  case 265:
                                               {
         // $$ = $1;
         // $$->addValue(makeOperatorValue($2));
         // $$->addValue(makeOperatorValue($3));
         // $$->addValue(parser->sinkFloatingValue($4));
     }
    break;

  case 266:
                                        {
        katana_parser_report_error(parser, (yyvsp[-1].location), "PropertyDeclarationCSSError");
    }
    break;

  case 267:
                      {
          (yyval.character) = '/';
      }
    break;

  case 269:
                    {
        (yyval.character) = ',';
    }
    break;

  case 271:
  { 
    (yyval.value) = (yyvsp[-1].value); 
    // $$.fValue *= $1; 
    katana_value_set_sign(parser, (yyval.value), (yyvsp[-2].integer));
  }
    break;

  case 272:
                                  { (yyval.value) = katana_new_value(parser); (yyval.value)->id = KatanaValueInvalid; (yyval.value)->isInt = false; katana_value_set_string(parser, (yyval.value), &(yyvsp[-1].string)); (yyval.value)->unit = KATANA_VALUE_STRING; }
    break;

  case 273:
                                 { (yyval.value) = katana_new_ident_value(parser, &(yyvsp[-1].string)); }
    break;

  case 274:
                                 { (yyval.value) = katana_new_value(parser); (yyval.value)->id = KatanaValueInvalid; katana_value_set_string(parser, (yyval.value), &(yyvsp[-1].string)); (yyval.value)->isInt = false; (yyval.value)->unit = KATANA_VALUE_DIMENSION; }
    break;

  case 275:
                                                { (yyval.value) = katana_new_value(parser); (yyval.value)->id = KatanaValueInvalid; katana_value_set_string(parser, (yyval.value), &(yyvsp[-1].string)); (yyval.value)->isInt = false; (yyval.value)->unit = KATANA_VALUE_DIMENSION; }
    break;

  case 276:
                               { (yyval.value) = katana_new_value(parser); (yyval.value)->id = KatanaValueInvalid; katana_value_set_string(parser, (yyval.value), &(yyvsp[-1].string)); (yyval.value)->isInt = false; (yyval.value)->unit = KATANA_VALUE_URI; }
    break;

  case 277:
                                        { (yyval.value) = katana_new_value(parser); (yyval.value)->id = KatanaValueInvalid; katana_value_set_string(parser, (yyval.value), &(yyvsp[-1].string)); (yyval.value)->isInt = false; (yyval.value)->unit = KATANA_VALUE_UNICODE_RANGE; }
    break;

  case 278:
                               { (yyval.value) = katana_new_value(parser); (yyval.value)->id = KatanaValueInvalid; katana_value_set_string(parser, (yyval.value), &(yyvsp[-1].string)); (yyval.value)->isInt = false; (yyval.value)->unit = KATANA_VALUE_PARSER_HEXCOLOR; }
    break;

  case 279:
                    { (yyval.value) = katana_new_value(parser); (yyval.value)->id = KatanaValueInvalid; 
    KatanaParserString tmp = {"#", 1}; 
    katana_value_set_string(parser, (yyval.value), &tmp); 
    (yyval.value)->isInt = false; (yyval.value)->unit = KATANA_VALUE_PARSER_HEXCOLOR; }
    break;

  case 282:
                    { /* Handle width: %; */
      (yyval.value) = katana_new_value(parser); (yyval.value)->id = KatanaValueInvalid; (yyval.value)->isInt = false; (yyval.value)->unit = 0;
  }
    break;

  case 284:
                     { (yyval.value) = katana_new_number_value(parser, 1, &(yyvsp[0].number), KATANA_VALUE_NUMBER); (yyval.value)->isInt = true; }
    break;

  case 285:
                          { (yyval.value) = katana_new_number_value(parser, 1, &(yyvsp[0].number), KATANA_VALUE_NUMBER); }
    break;

  case 286:
                          { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_PERCENTAGE); }
    break;

  case 287:
                   { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_PX); }
    break;

  case 288:
                   { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_CM); }
    break;

  case 289:
                   { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_MM); }
    break;

  case 290:
                   { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_IN); }
    break;

  case 291:
                   { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_PT); }
    break;

  case 292:
                   { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_PC); }
    break;

  case 293:
                    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_DEG); }
    break;

  case 294:
                    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_RAD); }
    break;

  case 295:
                     { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_GRAD); }
    break;

  case 296:
                     { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_TURN); }
    break;

  case 297:
                     { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_MS); }
    break;

  case 298:
                    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_S); }
    break;

  case 299:
                     { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_HZ); }
    break;

  case 300:
                      { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_KHZ); }
    break;

  case 301:
                   { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_EMS); }
    break;

  case 302:
                    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_PARSER_Q_EMS); }
    break;

  case 303:
                   { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_EXS); }
    break;

  case 304:
                    {
      (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_REMS);
      /* if (parser->m_styleSheet)
          parser->m_styleSheet->parserSetUsesRemUnits(true); */
  }
    break;

  case 305:
                   { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_CHS); }
    break;

  case 306:
                  { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_VW); }
    break;

  case 307:
                  { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_VH); }
    break;

  case 308:
                    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_VMIN); }
    break;

  case 309:
                    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_VMAX); }
    break;

  case 310:
                    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_DPPX); }
    break;

  case 311:
                   { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_DPI); }
    break;

  case 312:
                    { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_DPCM); }
    break;

  case 313:
                  { (yyval.value) = katana_new_dimension_value(parser, &(yyvsp[0].number), KATANA_VALUE_FR); }
    break;

  case 314:
                                                             {
        (yyval.value) = katana_new_function_value(parser, &(yyvsp[-3].string), (yyvsp[-1].valueList));
    }
    break;

  case 315:
                                                        {
        (yyval.value) = katana_new_function_value(parser, &(yyvsp[-2].string), NULL);
    }
    break;

  case 316:
                                                                      {
        YYERROR;
    }
    break;

  case 318:
                              { (yyval.value) = (yyvsp[0].value); (yyval.value)->fValue *= (yyvsp[-1].integer); }
    break;

  case 319:
                    {
        (yyval.character) = '+';
    }
    break;

  case 320:
                      {
        (yyval.character) = '-';
    }
    break;

  case 321:
                                       {
        (yyval.character) = '*';
    }
    break;

  case 322:
                                       {
        (yyval.character) = '/';
    }
    break;

  case 325:
                                                                        {
        (yyval.valueList) = (yyvsp[-2].valueList);
        katana_value_list_insert(parser, katana_new_operator_value(parser, '('), 0, (yyval.valueList));
        katana_new_operator_value(parser, ')');
        katana_value_list_add(parser, katana_new_operator_value(parser, ')'), (yyval.valueList));
    }
    break;

  case 326:
                                                        {
        YYERROR;
    }
    break;

  case 327:
                   {
        (yyval.valueList) = katana_new_value_list(parser);
        katana_value_list_add(parser, (yyvsp[0].value), (yyval.valueList));
    }
    break;

  case 328:
                                                       {
        (yyval.valueList) = (yyvsp[-2].valueList);
        katana_value_list_add(parser, katana_new_operator_value(parser, (yyvsp[-1].character)), (yyval.valueList));
        katana_value_list_add(parser, (yyvsp[0].value), (yyval.valueList));
    }
    break;

  case 329:
                                                             {
        (yyval.valueList) = (yyvsp[-2].valueList);
        katana_value_list_add(parser, katana_new_operator_value(parser, (yyvsp[-1].character)), (yyval.valueList));
        katana_value_list_steal_values(parser, (yyvsp[0].valueList), (yyval.valueList));
    }
    break;

  case 331:
                                                                                            {
//        $$.setFromFunction(parser->createFloatingFunction($1, parser->sinkFloatingValueList($3)));
        (yyval.value) = katana_new_function_value(parser, &(yyvsp[-4].string), (yyvsp[-2].valueList));
    }
    break;

  case 332:
                                                                            {
        YYERROR;
    }
    break;

  case 336:
                                             {
        katana_parser_report_error(parser, (yyvsp[-1].location), "InvalidRuleCSSError");
    }
    break;

  case 343:
                                                                                          {
        // parser->reportError($4, InvalidSupportsConditionCSSError);
        // parser->popSupportsRuleData();
    }
    break;

  case 344:
                                                                              {
        // parser->markViewportRuleBodyEnd();
    }
    break;

  case 347:
                                                      {
        // parser->resumeErrorLogging();
        // parser->reportError($1, InvalidRuleCSSError);
    }
    break;

  case 348:
                                                                                      {
        katana_parser_report_error(parser, (yyvsp[-3].location), "InvalidRuleCSSError invalid_rule");
    }
    break;

  case 352:
                                                                        {
        katana_parser_report_error(parser, (yyvsp[-2].location), "InvalidRuleCSSError invalid_rule_header");
    }
    break;

  case 355:
               {
        katana_end_invalid_rule_header(parser);
   }
    break;

  case 356:
                                     {
        katana_parser_report_error(parser, parser->position, "invalidBlockHit");
    }
    break;

  case 367:
                {
        (yyval.location) = katana_parser_current_location(parser, &yylloc);
    }
    break;

  case 368:
                {
        // parser->setLocationLabel(parser->currentLocation());
    }
    break;



      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;
  *++yylsp = yyloc;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (&yylloc, scanner, parser, YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = YY_CAST (char *, YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yymsg_alloc)));
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (&yylloc, scanner, parser, yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }

  yyerror_range[1] = yylloc;

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval, &yylloc, scanner, parser);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;

      yyerror_range[1] = *yylsp;
      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp, yylsp, scanner, parser);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  yyerror_range[2] = yylloc;
  /* Using YYLLOC is tempting, but would change the location of
     the lookahead.  YYLOC is available though.  */
  YYLLOC_DEFAULT (yyloc, yyerror_range, 2);
  *++yylsp = yyloc;

  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (&yylloc, scanner, parser, YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif


/*-----------------------------------------------------.
| yyreturn -- parsing is finished, return the result.  |
`-----------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval, &yylloc, scanner, parser);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[+*yyssp], yyvsp, yylsp, scanner, parser);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}

