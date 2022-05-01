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
.align 2
.global main
.type main,%function

main:
    @@ grabar registro de enlace en la pila
	stmfd sp!, {lr}	/* SP = R13 link register = R14*/

    @@ Bienvenida al programa
    ldr r0,=mensaje_ingreso
    bl puts

    mov r10,#2

accion:
    subs r10,#1 @@ determinar que accion se debe de realizar
    bpl solicitud @@ solicitud de datos
    bmi analisis @@ analisis de datos

solicitud:
    @@ comparador que analiza que tipo de dato debe de pedir
    @@ se usa en todo el programa, indicando el dato que se analiza
    cmp r10,#1 
    ldreq r0,=ingreso_nombre
    ldrne r0,=ingreso_apellido
    bl puts

    @@ solicitud de datos
	ldr r0,=formato_string
    cmp r10,#1
	ldreq r1,=nombre
    ldreq r4,=nombre
    ldrne r1,=apellido
    ldrne r4,=apellido
	bl scanf

tamano:
    @@ recorrer cadena hasta encontrar un valor null
    ldrb r1,[r4],#1
    cmp r1,#0
    addne r5,#1
    bne tamano

    @@ guardar el tamano del nombre o apellido, según sea el caso
    cmp r10,#1
    ldreq r1,=cantidad_nombre
    ldrne r1,=cantidad_apellido
    str r5,[r1]
    mov r5,#0
    
ultima:
    cmp r10,#1
    ldreq r4,=nombre
    ldreq r9,=cantidad_nombre
    ldrne r4,=apellido
    ldrne r9,=cantidad_apellido

    @@ recorrer la cadena pre order
    ldr r9,[r9]
    sub r9,#1
    ldr r6,[r9,r4]
    
    @@ guardar el ultimo caracter no vacio de la cadena
    cmp r10,#1
    ldreq r1,=ultima_nombre
    ldrne r1,=ultima_apellido
    str r6,[r1]

    add r9,#1

vocales:
    @@ recorrer toda la cadena post order
    ldrb r1,[r4],#1

    @@ comparacion con caracteres segun codigo ASCII
    cmp r1,#65 @@ A
    addeq r7,#1
    cmp r1,#69 @@ E
    addeq r7,#1
    cmp r1,#73 @@ I
    addeq r7,#1
    cmp r1,#79 @@ O
    addeq r7,#1
    cmp r1,#85 @@ U
    addeq r7,#1
    cmp r1,#97 @@ a
    addeq r7,#1
    cmp r1,#101 @@ e
    addeq r7,#1
    cmp r1,#105 @@ i
    addeq r7,#1
    cmp r1,#111 @@ o
    addeq r7,#1
    cmp r1,#117 @@ u
    addeq r7,#1

    @@ decremento y autoanalisis del tamano de la cadena
    subs r9,#1 
    bne vocales 

    @@ guardar cantidad de vocales
    cmp r10,#1
    ldreq r1,=vocales_nombre
    ldrne r1,=vocales_apellido
    str r7,[r1]
    mov r7,#0

    b accion

analisis:
    ldr r0,=criterios
    bl puts

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

    @@ Ambos nombre y apellido tienen el mismo número de vocales 
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

salir:
    @@salida segura
    mov r0, #0
    mov r3, #0
    ldmfd sp!, {lr}
    bx lr

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
formato_string:
	.asciz " %s"
formato_char:
    .asciz " %c"
formato_d:
    .asciz " %d"
mensaje_ingreso: 
    .asciz "Bienvenido a su programa MiPrimerBebe.com"
ingreso_nombre:
	.asciz "Ingrese el nombre del Bebe: "
ingreso_apellido:
    .asciz "\nIngrese el apellido del Bebe: "
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
