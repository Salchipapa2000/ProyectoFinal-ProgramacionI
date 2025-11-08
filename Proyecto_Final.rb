#Proyecto final
#Autor Jeanneth Moran

# Variable publicas, se pueden consultar en todos los metodos
$cf_alumnos = "registro_estudiantes.txt"
# array publico que contiene los datos de los estudiantes
$hash_estudiantes = {}
# estado
$lguardar = 0

# metodod para mostrar mensajes
def mensaje(ctexto)
	puts ctexto
	puts "Presiona Enter para continuar..."
	STDIN.gets
end

# buscar estudiante
def buscar(ntipo = 0)  # = 0 por si no se envia nada el valor es 0
	print "Ingrese ID del estudiante (entero positivo): "
	input = gets.chomp #Listo para recibir el dato
	id = input.to_i  #cambiarla cadena a entero
	
	if id.nil? || id <= 0 #Verificamos si está vacío o es menor a 0
		mensaje( "ID inválido. Debe ser un número entero positivo." )
		return 0
	end
	
	if ntipo == 1
		if $hash_estudiantes.key?(id) #Verificamos que no hayan iguales 
			mensaje("Ya existe un estudiante con ese ID.")
			return
		end
	else
		unless $hash_estudiantes.key?(id) #Verificamos que existe
			mensaje("ID no existe.")
			return 0
		end
	end
	return id
end

#-------------------Método para calcular promedio ---------------
def calcular_promedio(notas)
	return 0 if notas.empty?
	#map convierte con to_f a valores flotantes los valores strig del array
	# con sum sumamos todos los valore, luego size nos dice cuantos elementos hay en el array para que sea el denominador.
	notas.map(&:to_f).sum / notas.size
end



#----Definimos para poder cargar los datos del txt ---------
def cargar_datos()
	# si no existe el archivo lo creamos
	if !File.exist?($cf_alumnos)
		# se crea el archivo
		File.write($cf_alumnos,"")
	else
	
		#leemos el archivo y lo pasamos al array
		aestudiantes = File.readlines($cf_alumnos)
		
		# pasar el array a hash
		aestudiantes.each do |fila_string|
			# revisar si la linea contiene los datos correctos
			if fila_string =~ /^ID:\s*(\d+)\s*\|\s*nombre:\s*(.*?)\s*\|\s*notas:\s*(.*)$/
				# pasar la linea a array
				fila_array = fila_string.split("|")
				# quedaria en fila_array algo asi {"ID: 10", "nombre: Juan Perez", "nota: (Sin nOTAS)"}
				
				# recuperar el id
				nid =  fila_array[0].split()[1].to_i
				#  la posicion del indice 0 "ID: 10" -> Se transforma a array {"ID",10} -> tomamos la posicion 1 "10" y la convertimos a entero to_i -> 10

				# completamos el hash
				$hash_estudiantes[nid] = { nombre: fila_array[1].split(":")[1], notas: fila_array[2].split(":")[1].split(",") }
				# para las otras posiciones, tomamos fila_array y usamos la posicion 1 {"nombre: el nombre de alguien"} -> lo pasamos a array separando por : {"nombre","el nombre de alguien"} y tomamos la posicion 1
				# para las notas lo mismo, tomamos fila_array y usamos la posicion 2 {"notas: (sin notas)"} -> lo pasamos a array separando por : {"notas","[]"} y tomamos la posicion 1 para convertirla en array
				
			end
		end
	end
	#Deberia verse asi: "ID: 1 | Nombre: Franco Sanchez | Notas: 90.5, 80.0, 100.0"
end

#--opcion 1---------------Método registro de estudiantes ---------------
def registrar_estudiante()
	#Limpiar la pantallas
	system("CLS")
	# solicitar el id
	id = buscar(1)
	if id == 0
		return
	end

	# mostrar el nombre
	puts ""
	print "Ingrese nombre completo: "
	nombre = gets.chomp.strip
	if nombre.empty? #Verificamos que el nombre no esté vacío.
		mensaje("El nombre no puede estar vacío")
		return
	end
	# agregamos los datos a nuestro hash
	$hash_estudiantes[id] = { nombre: nombre, notas: [0,0,0] }
	puts ""
	mensaje( "Estudiante '#{nombre}' registrado con ID #{id}." )
	# indicamos que hay un cambio, para que guarde al salir
	$lguardar = 1
  
end

# opcion 2-----------------Método para ingresar notas ------
def ingresar_notas()
	system("cls")
	# solicitar el ID
	id = buscar()
	if id == 0
		return
	end
	
	nombre = $hash_estudiantes[id][:nombre]
	puts ""
	puts "Ingresando notas para #{nombre}:"
	puts ""
	notas = []
	# ciclo de 3 vueltas
	3.times do |i|
		print "Nota #{i + 1} (0.00 - 100.00):" #Definimos máximo y mínimo.
		input = gets.chomp
		nota = Float (input) rescue nil #Float convierte el string a un decimales.
		# revisarmas que el numero este en el rango, el operador && significa Y
		if nota && nota >= 0.0 && nota <= 100.0
			notas << nota
		else
			mensaje("Por favor, ingrese un número entre 0.00 y 100.00")
			next
		end
	end
	puts ""
	# actualizamos el Hash
	$hash_estudiantes[id][:notas] = notas
	mensaje("Notas registradas: #{notas.map { |n| format('%.2f', n) }.join(', ')}") #El %2f.n es para poner 2 decimales.
	# indicamos que hay un cambio, para que guarde al salir
	$lguardar = 1
end

#--opcion 3----Método para consultar el promedio
def consultar_promedio()
	system("cls")
	# solicitamos el id
	id = buscar()
	if id == 0
		return
	end
	# recuperamos la linea segun el id
	info = $hash_estudiantes[id]
	puts "Nombre: #{info[:nombre]}"
	# recumperamos el array que esta en notas del hash
	notas = info[:notas]
	if notas.empty?
		puts "No hay notas registradas."
	else
		promedio = calcular_promedio(notas)
		# para desplegar, notas las pasamos a strig con map y usamos format para dar formato % <- este numero, que tenga .2 dos decimales como f punto flotante y con .join, que una la cadena con una ,
		puts "Notas: #{notas.map { |n| format('%.2f', n) }.join(', ')}"
		puts "Promedio: #{format('%.2f', promedio)}"
	end
	mensaje("")
end

#-opcion 4---------------Método para listar a todos los estudiantes -------------
def listar_estudiantes()
	if $hash_estudiantes.empty? #Verificamos que no esté vacío.
		mensaje(  "No hay estudiantes registrados." )
		return
	end
	system("cls")
	puts "============LISTADO DE ESTUDIANTES ===================="
	
	puts "ID |  Nombre                                  | Notas                                    | Promedio" #Orden.
	puts "-----------------------------------------------------------------------------------------------"
	# recorremos el hash de forma ordenada sort he iteramos
	$hash_estudiantes.sort.each do |id, info| #Llamamos a todos los métodos y ordenamos alfabeticamente.
		aNotas = info[:notas]
		# convertimos a cadena separados por ,
		cNotas = aNotas.join(", ")
		#calculamos el promedio, enviando como argumento el array aNotas
		prom = calcular_promedio(aNotas)

		prom_texto = prom ? format('%2f', prom) : "N/A"
		puts "#{id} | #{info[:nombre].ljust(40," ")} | #{cNotas.delete("\n").ljust(40," ")} | #{prom_texto}"
		# ljust convierte el string a una lunguitud de 40 rellenando con espacios
		# delete quita el salto de linea "\n"
	end
	mensaje("")
end

#-para salir--------------Método para guardar --------------
def guardar_y_salir()
	# revisar si hay datos que guardar
	if $lguardar == 1
	    puts "Datos guardados en #{$cf_alumnos}"
		# abrir el archivo en modo escritura
		File.open($cf_alumnos, 'w') do |archivo| 
			# recorrer el hash
			$hash_estudiantes.each do |id, info| #Por cada linea del hash colocar la id y la información.
				notas = info[:notas]
				# si no hay notos, colocar que no hay notas
				if notas.nil? || notas.empty? #Verificamos que no esté vacío.
					archivo.puts "ID: #{id} | nombre: #{info[:nombre]} | notas: [0 ,0 ,0]" #Forma de colocar los datos si no hay notas.
				else
					# si hay agregar las notas correspondientes
					notas_texto = notas.map { |n| format('%.2f', n) }.join(', ')
					archivo.puts "ID: #{id} | nombre: #{info[:nombre]} | notas: #{notas_texto}" #Forma de coloar si si tenemos notas.
				end
			end
		end	
	end
end



#------------------Mostrar menu principal --------------
def mostrar_menu
	puts "===== SISTEMA DE GESTIÓN DE ALUMNOS ====="
	puts ""
	puts "1. Registrar estudiante"
	puts "2. Ingresar notas"
	puts "3. Consultar promedio por estudiante"
	puts "4. Listar todos los estudiantes"
	puts "5. Guardar y salir"
	puts ""
	print "Seleccione una opción (1-5):"  # print para que no salte de linea
end




#*---------------Inicio de la función principal ----------------------
# Revisa si existe el archivo, lo crea y carga los datos existentes a un array
cargar_datos()

#Bucle principal del menú
loop do #Loop es para el bucle.
    system("CLS")
    mostrar_menu
    opcion = gets.chomp.to_i
  
    case opcion
    when 1
        registrar_estudiante()
    when 2
        ingresar_notas()
    when 3
        consultar_promedio()
    when 4
        listar_estudiantes()
    when 5
        guardar_y_salir()
        mensaje( "Saliendo... ¡Hasta luego!" )
		system("CLS")
        break
    else
		system("CLS")
        mensaje( "Opción inválida. Intentelo nuevamente Elige entre 1 y 5." )
    end
end