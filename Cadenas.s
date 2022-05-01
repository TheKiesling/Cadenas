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
* Emily Elvia Perez Alarcón 21385
* Jose Pablo Kiesling Lange 21581
* -------------------------------
* Cadenas.s
* Herramienta para parejas que están esperando su primer bebé, la cual 
* calcula la compatibilidad del primer nombre con el primer apellido. 
 -------------------------------------------------------------------------------------- */

/* --------------------------------------- TEXT --------------------------------------- */
.text
.align 2
.global main
.type main,%function

/* ---------------- MAIN ---------------- */ 
main:
    @@ grabar registro de enlace en la pila
	stmfd sp!, {lr}	/* SP = R13 link register = R14*/

    @@ Bienvenida al programa
    ldr r0,=mensaje_ingreso
    bl puts

    @@ Asignacion de bandera
    ldr r10,=tipo_accion
    ldr r10,[r10]

accion:
    subs r10,#1 @@ determinar que accion se debe de realizar
    bpl solicitud @@ solicitud de datos
    bmi salir @@ analisis de datos

solicitud:
    cmp r10,#1
    ldreq r0,=ingreso_nombre
    ldrne r0,=ingreso_apellido
    bl puts

	ldr r0,=formato_string
    cmp r10,#1
	ldreq r1,=nombre
    ldreq r4,=nombre
    ldrne r1,=apellido
    ldrne r4,=apellido
	bl scanf

tamano:
    cmp r10,#1
    addeq r5,#1
    addne r7,#1
    ldrb r1,[r4],#1
    cmp r1,#0
    bne tamano

    cmp r10,#1
    subeq r5,#2
    subne r7,#2

ultima:
    cmp r10,#1
    ldreq r4,=nombre
    ldreq r6,[r5,r4]
    ldrne r4,=apellido
    ldrne r8,[r7,r4]
    b accion
/*
vocales:
    ldrb r1,[r4],#1
    cmp r1,#65
    addeq r6,#1
    subs r9,#1
    beq accion 
    bne vocales 
*/
salir:
    @@print
	ldr r0,=formato_string
	ldr r1,=nombre
	bl printf

    ldr r0,=formato_string
	ldr r1,=apellido
	bl printf

    ldr r0,=formato_char
	mov r1,r6
	bl printf

    ldr r0,=formato_string
	mov r1,r8
	bl printf


    ldr r0,=formato_d
	mov r1,r5
	bl printf

    ldr r0,=formato_d
	mov r1,r7
	bl printf

    @@salida segura
    mov r0, #0
    mov r3, #0
    ldmfd sp!, {lr}
    bx lr

/* --------------------------------------- DATA --------------------------------------- */
.data
.align 2

/* --Banderas --*/
tipo_accion: .word 2

/*-- Variables --*/
nombre: .asciz "                    "
apellido: .asciz "                    "
cantidad_nombre: .word 0
cantidad_apellido: .word 0
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
    .asciz "Ingrese el apellido del Bebe"
