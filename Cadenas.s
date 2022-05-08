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
* Cadenas.s
* Herramienta para parejas que estan esperando su primer bebe, la cual 
* calcula la compatibilidad del primer nombre con el primer apellido. 
 -------------------------------------------------------------------------------------- */

/* --------------------------------------- TEXT --------------------------------------- */
.text
.global main
main:
    @@ Bienvenida al programa
    /*--- SWI ---*/
    mov r7,#4 @ write
    mov r0,#1 @ pantalla
    mov r2,#40 @ tamano de cadena
    ldr r1,=mensaje_ingreso @ mensaje a imprimir
    swi 0

    mov r10,#2

    @@ determinar que accion se debe de realizar
    accion:
        subs r10,#1 
        bpl solicitud @@ solicitud de datos
        bmi analisis @@ analisis de datos

    @@ solictar el nombre o el apellido segun sea el caso
    solicitud:
        /*--- SWI ---*/
        mov r7,#4 @ write
        mov r0,#1 @ pantalla
        @@ comparador que analiza que tipo de dato debe de pedir
        @@ se usa en todo el programa, indicando el dato que se analiza
        cmp r10,#1 
        moveq r2,#28 @ tamano de cadena
        ldreq r1,=ingreso_nombre @ mensaje a imprimir
        movne r2,#31 @ tamano de cadena
        ldrne r1,=ingreso_apellido @ mensaje a imprimir
        swi 0
        
        @@ solicitud de datos
        /*--- SWI ---*/
        mov r7,#3 @ read
        mov r0,#0 @ teclado
        mov r2,#20 @ tamano de la cadena
        cmp r10,#1
        ldreq r1,=nombre @ variable donde se carga
        ldreq r4,=nombre
        ldrne r1,=apellido @ variable donde se carga
        ldrne r4,=apellido
        swi 0

    @ determinar el tamano de la cadena
    mov r5,#0
    bl _tamano

    @@ guardar el tamano de la cadena
    cmp r10,#1
    ldreq r1,=cantidad_nombre
    ldrne r1,=cantidad_apellido
    str r5,[r1]
    
    @ preparar registros en r4 cadena, y en r9 tamano
    cmp r10,#1
    ldreq r4,=nombre
    ldreq r9,=cantidad_nombre
    ldrne r4,=apellido
    ldrne r9,=cantidad_apellido
    ldr r9,[r9]
    bl _ultima @ ultimo caracter no vacio de la cadena

    @@ guardar el ultimo caracter no vacio de la cadena
    cmp r10,#1
    ldreq r1,=ultima_nombre
    ldrne r1,=ultima_apellido
    str r6,[r1]

    @ determinar la cantidad de vocales en la cadena
    add r9,#1
    mov r6,#0
    bl _vocales

    @@ guardar cantidad de vocales
    cmp r10,#1
    ldreq r1,=vocales_nombre
    ldrne r1,=vocales_apellido
    str r6,[r1]
    
    @ regresar a verificar la siguiente accion
    b accion

    @ analisis de las propiedades del nombre y apellido
    analisis:
        /*--- SWI ---*/
        mov r7,#4 @ write
        mov r0,#1 @ pantalla
        mov r2,#34 @ tamano de la cadena
        ldr r1,=criterios @ mensaje a imprimir
        swi 0

        @@ Ambos nombre y apellido tienen la misma cantidad de letras 
        ldr r1,=cantidad_nombre
        ldr r1,[r1]
        ldr r2,=cantidad_apellido
        ldr r2,[r2]
        cmp r1,r2
        addeq r8,#1
        ldr r0,=primer_criterio
        bl printf

        @@ Ambos nombre y apellido tienen el mismo número de vocales 
        ldr r1,=vocales_nombre
        ldr r1,[r1]
        ldr r2,=vocales_apellido
        ldr r2,[r2]
        cmp r1,r2
        addeq r8,#1
        ldr r0,=segundo_criterio
        bl printf

        @@ Ambos nombre y apellido tienen la misma última letra
        ldr r1,=ultima_nombre
        ldr r1,[r1]
        ldr r2,=ultima_apellido
        ldr r2,[r2]
        cmp r1,r2
        addeq r8,#1
        ldr r0,=tercer_criterio
        bl printf

        @@ Guardar punteo
        ldr r1,=punteo
        str r8,[r1]

        @@ Imprimir punteo 
        ldr r1,=punteo
        ldr r1,[r1]
        cmp r1,#2
        ldrpl r0,=aprobado
        ldrmi r0,=reprobado
        bl printf

        @@salida segura
        mov r7,#1
        swi 0

/* --------------------------------------- DATA --------------------------------------- */
.data
.align 2

/*-- Variables --*/
nombre: .asciz "                    "
apellido: .asciz "                    "
cantidad_nombre: .word 0
cantidad_apellido: .word 0
vocales_nombre: .word 0
vocales_apellido: .word 0
ultima_nombre: .word 0
ultima_apellido: .word 0
punteo: .word 0

/*-- Mensajes --*/
mensaje_ingreso: 
    .asciz "Bienvenido a su programa MiPrimerBb.com\n"
ingreso_nombre:
	.asciz "Ingrese el nombre del Bebe:\n"
ingreso_apellido:
    .asciz "\nIngrese el apellido del Bebe:\n"
criterios:
    .asciz "\n --- ANALISIS DE CRITERIOS --- \n"
primer_criterio:
    .asciz "Cantidad de letras de \n Nombre: %d \n Apellido: %d\n"
segundo_criterio:
    .asciz "\nCantidad de vocales de \n Nombre: %d \n Apellido: %d\n"
tercer_criterio:
    .asciz "\nUltima letra de \n Nombre: %c \n Apellido: %c\n"
aprobado:
    .asciz "\nEl nombre tiene %d puntos, esta aprobado\n"
reprobado:
    .asciz "\nEl nombre tiene %d puntos, intente un nuevo nombre\n"
