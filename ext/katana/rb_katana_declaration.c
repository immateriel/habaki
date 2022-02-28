/*
 * Declarations and values
 */
#include "rb_katana.h"

extern VALUE rb_Katana, rb_Output, rb_KError, rb_KPosition, rb_KArray, rb_Stylesheet,
    rb_MediaRule, rb_MediaQuery, rb_MediaQueryExp,
    rb_SupportsRule, rb_SupportsExp,
    rb_PageRule, rb_FontFaceRule, rb_StyleRule, rb_ImportRule, rb_NamespaceRule, rb_CharsetRule,
    rb_Selector, rb_SelectorData, rb_Declaration, rb_Value, rb_QualifiedName, rb_ValueFunction;

// Declaration

/*
 * @return [String, nil]
 */
VALUE rb_declaration_prop(VALUE self)
{
    KatanaDeclaration *c_decl;
    Data_Get_Struct(self, KatanaDeclaration, c_decl);
    if (c_decl->property)
        return rb_str_new2(c_decl->property);
    else
        Qnil;
}

/*
 * @return [Boolean]
 */
VALUE rb_declaration_important(VALUE self)
{
    KatanaDeclaration *c_decl;
    Data_Get_Struct(self, KatanaDeclaration, c_decl);
    if (c_decl->important)
        return Qtrue;
    else
        return Qfalse;
}


/*
 * @return [String, nil]
 */
VALUE rb_declaration_raw(VALUE self)
{
    KatanaDeclaration *c_decl;
    Data_Get_Struct(self, KatanaDeclaration, c_decl);
    if (c_decl->raw)
        return rb_str_new2(c_decl->raw);
    else
        return Qnil;
}

/*
 * @return [Katana::Array<Katana::Value>, nil]
 */
VALUE rb_declaration_values(VALUE self)
{
    KatanaDeclaration *c_declaration;
    Data_Get_Struct(self, KatanaDeclaration, c_declaration);

    if (c_declaration->values)
    {
        VALUE array = Data_Wrap_Struct(rb_KArray, NULL, NULL, c_declaration->values);

        VALUE sing = rb_singleton_class(array);
        rb_define_method(sing, "each", rb_value_each, 0);

        return array;
    }
    else
    {
        return Qnil;
    }
}

/*
 * @return [SourcePosition]
 */
VALUE rb_declaration_position(VALUE self)
{
    KatanaDeclaration *c_decl;
    Data_Get_Struct(self, KatanaDeclaration, c_decl);
    return Data_Wrap_Struct(rb_KPosition, NULL, NULL, &c_decl->position);
}

// Value

/*
 * @return [String, nil]
 */
VALUE rb_value_raw(VALUE self)
{
    KatanaValue *c_val;
    Data_Get_Struct(self, KatanaValue, c_val);
    if (c_val->raw)
        return rb_str_new2(c_val->raw);
    else
        return Qnil;
}

/*
 * @return [Symbol]
 */
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
        id = rb_intern("undefined");
        break;
    }
    return ID2SYM(id);
}

/*
 * @return [String, Float, nil]
 */
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
    case KATANA_VALUE_DIMENSION:
        val = rb_str_new2(c_val->string);
        break;
    case KATANA_VALUE_UNKNOWN:
        val = rb_str_new2(c_val->string);
        break;
    default:
        fprintf(stderr, "KATANA: unsupported value unit %d (%s)\n", c_val->unit, c_val->string);
        break;
    }

    return val;
}

// ValueFunction

/*
 * @return [String, nil]
 */
VALUE rb_value_function_name(VALUE self)
{
    KatanaValueFunction *c_val;
    Data_Get_Struct(self, KatanaValueFunction, c_val);
    if (c_val->name)
        return rb_str_new2(c_val->name);
    else
        return Qnil;
}

/*
 * @return [Katana::Array<Katana::Value>, nil]
 */
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

void init_katana_declaration()
{
    // Declaration
    rb_Declaration = rb_define_class_under(rb_Katana, "Declaration", rb_cObject);
    rb_define_method(rb_Declaration, "property", rb_declaration_prop, 0);
    rb_define_method(rb_Declaration, "important", rb_declaration_important, 0);
    rb_define_method(rb_Declaration, "values", rb_declaration_values, 0);

    rb_define_method(rb_Declaration, "position", rb_declaration_position, 0);
    rb_define_method(rb_Declaration, "raw", rb_declaration_raw, 0);

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
}