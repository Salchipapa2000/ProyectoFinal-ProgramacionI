Registro_estudiantes = 'estudiantes.txt'

estudiantes = {}

#Definimos para poder cargar los datos en txt ---------
def cargar_datos(estudiantes)
  return unless File.exist?(Registro_estudiantes) #Verificamos que si existe.

File.readlines(Registro_estudiantes, chomp: true).each do |linea| #En el documento por cada linea realizamos el proceso.
  next if linea.strip.empty? #Verificamos que no haya lineas vacías.

#Deberia verse asi: "ID: 1 | Nombre: Franco Sanchez | Notas: 90.5, 80.0, 100.0"
if linea =~ /^ID:\s*(\d+)\s*\|\s*Nombre:\s*(.*?)\s*\|\s*Notas:\s*(.*)$/
  id = $1.to_i #Definimos cada objeto, eliminando espacios y definiendo interger para números.
  nombre = $2.strip
  notas_texto = $3.strip
  notas = if notas_texto == "(sin notas)" #Por si acaso aún no hay notas.
        []
      else
        notas_texto.split(',').map {|n| n.strip.to_f }
      end
    estudiantes[id] = { nombre: nombre, notas: notas }
  end
end
rescue => e
  puts "Error al leer archivo TXT:"
end

#-----------------Método para guardar --------------
def guardar_datos(estudiantes) #Definimos
  File.open(Registro_estudiantes, 'w') do |file| 
    estudiantes.each do |id, info| #Por cada linea colocar la id y la información.
      notas = info[:notas]
      if notas.nil? || notas.empty? #Verificamos que no esté vacío.
        file.puts "ID: #{id} | Nombre: #{info[:nombre]} | Notas: (sin notas)" #Forma de colocar los datos si no hay notas.
      else
        notas_texto = notas.map { |n| format('%.2f', n) }.join(', ')
        file.puts "ID: #{id} | Nombre: #{info[:nombre]} | Notas: #{notas_texto}" #Forma de coloar si si tenemos notas.
      end
    end
  end
rescue => e
  puts "Error al guardar archivo TXT"
end

#------------------Mostrar menu principal --------------
def mostrar_menu
puts
puts "===== SISTEMA DE GESTIÓN DE ALUMNOS ====="

puts "1. Registrar estudiante"
puts "2. Ingresar notas"
puts "3. Consultar promedio por estudiante"
puts "4. Listar todos los estudiantes"
puts "5. Guardar y salir"
puts "Seleccione una opción:"
end

#--------------------Método registro de estudiantes ---------------
def registrar_estudiante(estudiantes)
  print "Ingrese ID (entero positivo): "
  input = gets.chomp #Listo para recibir el dato
  id = integer (input) rescue nil #Rescue para evtar bloqueos.
  if id.nil? || id <= 0 #Verificamos si está vacío o es menor a 0
    puts "ID inválido. Debe ser un número entero positivo."
    return
  end
  if esudiantes.key?(id) #Verificamos que no hayan iguales 
    puts "Ya existe un estudiante con ese ID."
    return
  end
  print "Ingrese nombre completo: "
  nombre = gets.chomp.strip
  if nombre.empty? #Verificamos que el nombre no esté vacío.
    puts "El nombre no puede estar vacío"
    return
  end
  estudiantes[id] = { nombre: nombre, notas: [] }
  puts "Estudiante '#{nombre}' registrado con ID #{id}."
end

#-----------------Método para ingresar notas ------
def ingresar_notas(estudiantes)
  print "Ingrese ID del estudiante: "
  id = Integer(gets.chomp) rescue nil #Definimos el dato como numérico.
  unless id && estudiantes.key?(id) #Verificamos que no esté vacío.
    puts "No existe un estudiante con ese ID."
    return
end
nombre = estudiantes[id][:nombre]
puts "Ingresando notas para #{nombre}:"
notas = []
3.times do |i|
  loop do
    print "Nota #{i + 1} (0.00 - 100.00):" #Definimos máximo y mínimo.
    input = gets.chomp
    nota = Float (input) rescue nil #Float para decimales.
    if nota && nota >= 0.0 && nota <= 100.0
      notas << nota
      break
    else
      puts "Por favor, ingrese un número entre 0.00 y 100.00"
    end
  end
end
estudiantes[id][:notas] = notas
puts "Notas registradas: #{notas.map { |n| format ('%.2f', n) }.join(', ')}" #El %2f.n es para poner 2 decimales.
end

#-------------------Método para calcular promedio ---------------
def calcular_promedio(estudiantes)
  return nil if notas.empty?
  notas.sum / notas.size.to_f
end
#-------------------Método para consultar el promedio
def consultar_promedio(estudiantes)
  print "Ingrese ID del estudiante: "
  id = Integer(gets.chomp) rescue nil
  unless id && estudiantes.key?(id)
    puts "No existe un estudiante con ese ID."
    return
  end
  info = estudiantes[id]
  puts "Nombre: #{info[:nombre]}"
  notas = info[:notas]
  if notas.empty?
    puts "No hay notas registradas."
  else
    promedio = calcular_promedio(notas)
    puts "Notas: #{notas.map [ |n| format ('%.2f', n)].join(',')}"
    puts "Promedio: #{format('%.2f', promedio)}"
  end
end


#----------------Método para listar a todos los estudiantes -------------
def listar_estudiantes(estudiantes)
  if estudiantes.empty? #Verificamos que no esté vacío.
    puts "No hay estudiantes registrados."
    return
  end
  puts "ID | Nombre | Promedio" #Orden.
  puts "-------------------------------"
  estudiantes.sort.each do |id, info| #Llamamos a todos los métodos y ordenamos alfabeticamente.
    prom = calcular_promedio(info[:notas])
    prom_texto = prom ? format('%2f', prom) : "N/A"
    puts "#{id} | #{info[:nomre]} | #{prom_texto}"
  end
end


#*---------------Inicio de la función principal ----------------------

cargar_datos(estudiantes)
#Bucle principal del menú
puts "Datos cargados desde #{Registro_estudiantes}." if File.exist?(Registro_estudiantes)

loop do #Loop es para el bucle.
  mostrar_menu
  opcion = gets.chomp.to_i
  
  case opcion

  when 1
    registra_estudiante(estudiantes)
  when 2
      ingresar_notas(estudiantes)
  when 3
      consultar_promedio(estudiantes)
  when 4
      listar_estudiantes(estudiantes)
  when 5
  guardar_y_salir(estudiantes)
  puts "Datos guardados en #{Registro_estudiantes}"
  puts "Saliendo... ¡Hasta luego!"
  break
else
    puts "Opción inválida. Intentelo nuevamente Elige entre 1 y 5."
  end
end

