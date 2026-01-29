CLASS zcl_mm_migo_http DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES : BEGIN OF ty,

              PurchaseOrder      TYPE string,
              PurchaseOrderItem  TYPE string,
              OrderQuantity      TYPE string,
              Material           TYPE string,
              BaseUnit           TYPE string,
              ProductDescription TYPE string,
              StoLoc             TYPE string,
              Batch              TYPE string,
              Supplier           TYPE string,
              AcceptQty          TYPE STRing,
            END OF ty.

    CLASS-DATA tabdata TYPE TABLE OF ty.

    TYPES : BEGIN OF ty1,
              DocumentDate   TYPE sy-datum,
              PostingDate    TYPE sy-datum,
              DocHeadText    TYPE string,
              DeliveryNote   TYPE string,
              GateEntry      TYPE string,
              FirstTableData LIKE tabdata,
            END OF ty1.

    CLASS-DATA tab1 TYPE ty1.

    INTERFACES if_http_service_extension.

    CLASS-METHODS
      get_mat
        IMPORTING VALUE(mat)      TYPE i_product-Product
        RETURNING VALUE(material) TYPE i_product-Product. "char18.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MM_MIGO_HTTP IMPLEMENTATION.


  METHOD get_mat.
    DATA: matnr TYPE i_product-Product , " char18.
          Material1 type char18,
          Material2 type i_product-Product .


*    matnr = |{ mat ALPHA = IN }|.
*    material = matnr.


    Material1 = |{ mat ALPHA = IN }|.     "When Product Length = 18
    material2 = |{ mat ALPHA = IN }|.     "When Product Length = 40

    select single product from I_Product where Product = @material1 into @data(mat1).
    if sy-subrc <> 0.
     select single product from I_Product where Product = @material2 into @mat1.
      endif.
       material = mat1.

  ENDMETHOD.


  METHOD if_http_service_extension~handle_request.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(req) = request->get_form_fields( ).
    response->set_header_field( i_name  = 'Access-Control-Allow-Origin'
                                i_value = '*' ).
    response->set_header_field( i_name  = 'Access-Control-Allow-Credentials'
                                i_value = 'true' ).
    DATA(body) = request->get_text( ).

    xco_cp_json=>data->from_string( body )->write_to( REF #( tab1 ) ).

    DATA json TYPE string.
    IF tab1 IS INITIAL.
      RETURN.
    ENDIF.

    MODIFY ENTITIES OF i_materialdocumenttp
           ENTITY materialdocument
           CREATE FROM VALUE #( ( %cid                       = 'My%CID_1'
                                  goodsmovementcode          = '01'
                                  postingdate                = tab1-postingdate  " RESPO-postingdate    " sy-datum
                                  documentdate               = tab1-documentdate " respo-docdate " sy-datum
                                  MaterialDocumentHeaderText = tab1-docheadtext "'  ' " Respo-challan
                                  %control-goodsmovementcode = cl_abap_behv=>flag_changed
                                  %control-postingdate       = cl_abap_behv=>flag_changed
                                  %control-documentdate      = cl_abap_behv=>flag_changed ) )

           ENTITY materialdocument
           CREATE BY \_materialdocumentitem
           FROM VALUE #(
               ( %cid_ref = 'My%CID_1'
                 %target  = VALUE #(
                     FOR any IN tab1-firsttabledata  INDEX INTO i
                     ( %cid                      = |My%CID_{ i }_001|
                       material                  = get_mat( mat = conv #( any-material ) )
                       plant                     = '1001'
                       storagelocation           = any-stoloc
                       goodsmovementtype         = '101'
                       InventorySpecialStockType = ' ' " 'E'
                       Supplier                  = |{ any-supplier ALPHA = IN }| " '0001100157'
                       Customer                  = ' '
                       quantityinentryunit       = any-acceptqty " '20'
                       entryunit                 = SWITCH #( any-baseunit WHEN 'PC' THEN 'ST' ELSE any-baseunit )
                       PurchaseOrder             = |{ any-purchaseorder ALPHA = IN }|  " '1430000052'
                       PurchaseOrderItem         = |{ any-purchaseorderitem ALPHA = IN }| "  '00010'
                       goodsmovementrefdoctype   = 'B'
                       materialdocumentitemtext  = tab1-docheadtext
                       GoodsMovementReasonCode   = '0'
                       IsCompletelyDelivered     = ' ' ) ) ) )
           MAPPED   DATA(ls_create_mapped)
           FAILED   DATA(ls_create_failed)
           REPORTED DATA(ls_create_reported).
    COMMIT ENTITIES BEGIN
           RESPONSE OF i_materialdocumenttp
           FAILED DATA(commit_failed)
           REPORTED DATA(commit_reported).

    IF commit_failed-materialdocument IS NOT INITIAL.

      LOOP AT commit_reported-materialdocumentitem ASSIGNING FIELD-SYMBOL(<data>).
        DATA(mszty) = sy-msgty.
        DATA(msz_1) = | { sy-msgv1 } { sy-msgv2 }  { sy-msgv3 } { sy-msgv4 } Message Type- { sy-msgid } Message No { sy-msgno }  |.
      ENDLOOP.
      IF commit_failed-materialdocument IS INITIAL.
        CLEAR mszty.
      ENDIF.
    ELSE.
      LOOP AT ls_create_mapped-materialdocument ASSIGNING FIELD-SYMBOL(<keys_header>).
        IF mszty = 'E' OR mszty = 'W'.
          EXIT.
        ENDIF.
        CONVERT KEY OF i_materialdocumenttp
                FROM <keys_header>-%pid
                TO <keys_header>-%key.
      ENDLOOP.

      LOOP AT ls_create_mapped-materialdocumentitem ASSIGNING FIELD-SYMBOL(<keys_item>).
        IF mszty = 'E' OR mszty = 'W'.
          EXIT.
        ENDIF.
        CONVERT KEY OF i_materialdocumentitemtp
                FROM <keys_item>-%pid
                TO <keys_item>-%key.
      ENDLOOP.
    ENDIF.
    COMMIT ENTITIES END.
    DATA result TYPE string.
    IF mszty = 'E' OR mszty = 'W'.
      result = |ERROR { msz_1 } |.
    ELSE.

      IF <keys_header> IS ASSIGNED.

        DATA(grn) = <keys_header>-MaterialDocument.
        " data result type string .
        DATA result1 TYPE string.
        result = <keys_header>-MaterialDocument.
        result1 = <keys_header>-MaterialDocumentYear.
      ENDIF.
    ENDIF.

    IF mszty = 'E' OR mszty = 'W' OR grn IS INITIAL  .
      json = |ERROR { msz_1 } | .
    ELSE.
      CONCATENATE 'Material Document' result  'Created Suscessfully' INTO json SEPARATED BY ' '.
    ENDIF.
    response->set_text( json  ).
  ENDMETHOD.
ENDCLASS.
