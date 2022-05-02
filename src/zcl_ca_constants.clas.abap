class ZCL_CA_CONSTANTS definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_CA_CONSTANTS
*"* do not include other source files here!!!

  class-methods OBTENER_CONSTANTES
    importing
      !I_ID type PROGNAME
      !I_CONSTANTE type BRF_CONSTANT
    exporting
      !C_VALOR type ANY .
  class-methods OBTENER_CONSTANTES_PROGRAMA
    importing
      !I_ID type PROGNAME
      !I_PATRON type BRF_CONSTANT optional
    exporting
      !C_VALORES type TABLE .
  class-methods OBTENER_CONSTANTES_EN_RANGES
    importing
      !I_ID type PROGNAME
      !I_PATRON type BRF_CONSTANT
      !I_OPTION type ANY default 'EQ'
      !I_SIGN type ANY default 'I'
    changing
      !T_RANGES type STANDARD TABLE .
  class-methods GET_CONSTANTE_EN_TABLA
    importing
      !I_ID type PROGNAME
      !I_PATRON type BRF_CONSTANT
    changing
      !C_TABLA type ANY TABLE .
protected section.
*"* protected components of class ZCL_CA_CONSTANTS
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_CA_CONSTANTS
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_CA_CONSTANTS IMPLEMENTATION.


METHOD get_constante_en_tabla.
************************************************************************
* 6/21/19   smartShift project

************************************************************************


* Obtener los valores de la tabla de constantes
  SELECT valor FROM zzt_ca_constants INTO TABLE c_tabla
         WHERE id = i_id
           AND constante LIKE i_patron
         ORDER BY PRIMARY KEY.                                                                     "$sst: #601
ENDMETHOD.


METHOD obtener_constantes.
  DATA ld_valor TYPE zze_valor_cte.

  CLEAR c_valor.

  SELECT SINGLE valor FROM zzt_ca_constants INTO ld_valor
         WHERE id = i_id AND constante = i_constante.
  IF sy-subrc = 0.
    c_valor = ld_valor.
  ENDIF.

ENDMETHOD.


METHOD obtener_constantes_en_ranges.

* Uso: Rellena la tabla tipo ranges T_RANGES con los valores en la tabla ZZT_CA0401
* que cumplan ID = i_id y CONSTANTE = i_patron, donde i_patron puede ser una expresión
* del tipo 'BUKRS%', por ejemplo.


* Uso: Rellena la tabla tipo ranges T_RANGES con los valores en la tabla ZZT_CA0401
* que cumplan ID = i_id y CONSTANTE = i_patron, donde i_patron puede ser una expresión
* del tipo 'BUKRS%', por ejemplo.
  DATA it_valores        TYPE TABLE OF zze_valor_cte.
  DATA d_valor           TYPE zze_valor_cte.
  DATA: dref             TYPE REF TO data.
  FIELD-SYMBOLS: <wa>    TYPE any,
                 <campo> TYPE any.

* Obtener los valores de la tabla de constantes
  SELECT valor FROM zzt_ca_constants INTO TABLE it_valores
         WHERE id = i_id
           AND constante LIKE i_patron.

  IF sy-subrc = 0.
*   Crear una Work area del mismo tipo que una linea del ranges pasado por parámetro
    CREATE DATA dref LIKE LINE OF t_ranges.
    ASSIGN dref->* TO <wa>.

*   Asignamos y llenamos campo Sign
    ASSIGN COMPONENT 'SIGN'   OF STRUCTURE <wa> TO <campo>.
    IF sy-subrc = 0.
      <campo> = i_sign.
    ENDIF.

*   Asignamos y llenamos campo Option
    ASSIGN COMPONENT 'OPTION' OF STRUCTURE <wa> TO <campo>.
    IF sy-subrc = 0.
      <campo> = i_option.
    ENDIF.

*   Asignamos campo Low
    ASSIGN COMPONENT 'LOW' OF STRUCTURE <wa> TO <campo>.
    IF sy-subrc = 0.

*     Asignar todos los valores y llenar la tabla ranges.
      LOOP AT it_valores INTO d_valor.

        <campo> = d_valor.
        APPEND <wa> TO t_ranges.

      ENDLOOP.

    ENDIF.

  ENDIF.


*  FIELD-SYMBOLS: <wa> TYPE ANY,
*                 <campo> TYPE ANY.
*
*  SELECT valor AS low FROM ZZT_CA_constants INTO CORRESPONDING FIELDS OF TABLE  t_ranges
*         WHERE id = i_id
*           AND constante LIKE i_patron.
*
*  LOOP AT t_ranges ASSIGNING <wa>.
*
*    ASSIGN COMPONENT 'SIGN'   OF STRUCTURE <wa> TO <campo>.
*    IF sy-subrc = 0.
*      <campo> = 'I'.
*      ASSIGN COMPONENT 'OPTION' OF STRUCTURE <wa> TO <campo>.
*      IF sy-subrc = 0.
*        <campo> = 'EQ'.
*      ENDIF.
*    ENDIF.
*
*  ENDLOOP.

ENDMETHOD.


METHOD obtener_constantes_programa.


  IF i_patron IS NOT SUPPLIED.
    SELECT * FROM zzt_ca_constants INTO TABLE c_valores
          WHERE id = i_id.
  ELSE.
    SELECT * FROM zzt_ca_constants INTO TABLE c_valores
          WHERE id = i_id
            AND constante LIKE i_patron.
  ENDIF.


ENDMETHOD.
ENDCLASS.
