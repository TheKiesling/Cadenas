/* --------------------------------------------------------------------------------------
* #      #    #######    ########   #######   #          #######   ##      #    #########
* #     #        #       #          #         #             #      # #     #    #
* #    #         #       #          #         #             #      #  #    #    #
* ####           #       #####      #######   #             #      #   #   #    #    ####
* #    #         #       #                #   #             #      #    #  #    #       #
* #     #        #       #                #   #             #      #     # #    #       #
* #      #    ########   ########   #######   ########   #######   #      ##    #########
* 
* UNIVERSIDAD DEL VALLE DE GUATEMALA 
* Organización de computadoras y Assembler
* Ciclo 1 - 2022
* -------------------------------
* Emily Elvia Perez Alarcon 21385
* Jose Pablo Kiesling Lange 21581
* -------------------------------
* Analisis.s
* Subrutinas que calculan datos de una cadena de texto (puede ser un nombre o apellido)
* Las subrutinas son las siguientes:
* - Tamano: calcula el tamano de la cadena
* - Ultima: devuelve el ultimo caracter no vacio de la cadena
* - Vocales: calcula el numero de vocales en la cadena
 -------------------------------------------------------------------------------------- */

@Subrutina que calcula el tamano de la cadena
@Parametros de entrada:
@r4: cadena
@Parametros de salida
@r5: tamano
.global _tamano
_tamano:
    ldrb r1,[r4],#1
    cmp r1,#32
    addne r5,#1
    bne _tamano
    sub r5,#1
    mov pc,lr 

@Subrutina que devuelve el ultimo caracter no vacio de la cadena
@Parametros de entrada:
@r4: cadena
@r9: tamano de la cadena
@Parametros de salida
@r6: ultimo caracter no vacio
.global _ultima
_ultima:
    sub r9,#1
    ldr r6,[r9,r4]   
    mov pc,lr 

@Subrutina que calcula el numero de vocales en la cadena
@Parametros de entrada:
@r4: cadena
@r9: tamano de la cadena
@Parametros de salida
@r6: numero de vocales
.global _vocales
_vocales:
    @@ recorrer toda la cadena post order
    ldrb r1,[r4],#1

    @@ comparacion con caracteres segun codigo ASCII
    cmp r1,#65 @@ A
    addeq r6,#1
    cmp r1,#69 @@ E
    addeq r6,#1
    cmp r1,#73 @@ I
    addeq r6,#1
    cmp r1,#79 @@ O
    addeq r6,#1
    cmp r1,#85 @@ U
    addeq r6,#1
    cmp r1,#97 @@ a
    addeq r6,#1
    cmp r1,#101 @@ e
    addeq r6,#1
    cmp r1,#105 @@ i
    addeq r6,#1
    cmp r1,#111 @@ o
    addeq r6,#1
    cmp r1,#117 @@ u
    addeq r6,#1

    @@ decremento y autoanalisis del tamano de la cadena
    subs r9,#1 
    bne _vocales
    mov pc, lr
