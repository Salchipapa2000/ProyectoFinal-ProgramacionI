FILE_NAME = 'estudiantes.txt'

estudiantes = {}

#Definimos para poder cargar los datos en txt ---------
def cargar_datos(estudiantes)
  return unless File.exist?(FILE_NAME)

File.readlines(FILE_NAME, chomp: true).each do |linea|
  next if linea.strip.empty?

#Deberia verse asi: "ID: 1 | Nombre: Franco Sanchez | Notas: 90.5, 80.0, 100.0"
if linea =~ /^ID:\s*(\d+)\s*\|\s*Nombre:\s*(.*?)\s*\|\s*Notas:\s*(.*)$/
  id = $1.to_i
  nombre = $2.strip
  notas_texto = $3.strip
  notas = if notas_texto == "(sin notas)"
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

#Método para guardar --------------
def guardar_datos(estudiantes)
  File.open(FILE_NAME, 'w') do |file|
    estudiantes.each do |id, info|
      notas = info[:notas]
      if notas.nil? || notas.empty?
        file.puts "ID: #{id} | Nombre: #{info[:nombre]} | Notas: (sin notas)"
      else
        notas_texto = notas.map { |n| format('%.2f', n) }.join(', ')
        file.puts "ID: #{id} | Nombre: #{info[:nombre]} | Notas: #{notas_texto}"
      end
    end
  end
rescue => e
  puts "Error al guardar archivo TXT"
end

#Mostrar menu principal --------------
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

#Método registro de estudiantes ---------------
def registrar_estudiante(estudiantes)
  print "Ingrese ID (entero positivo): "
  input = gets.chomp
  id = integer (input) rescue nil
  if id.nil? || id <= 0
    puts "ID inválido. Debe ser un número entero positivo."
    return
  end
  if esudiantes.key?(id)
    puts "Ya existe un estudiante con ese ID."
    return
  end
  print "Ingrese nombre completo: "
  nombre = gets.chomp.strip
  if nombre.empty?
    puts "El nombre no puede estar vacío"
    return
  end
  estudiantes[id] = { nombre: nombre, notas: [] }
  puts "Estudiante '#{nombre}' registrado con ID #{id}."
end

#Método para ingresar notas ------
def ingresar_notas(estudiantes)
  print "Ingrese ID del estudiante: "
  id = Integer(gets.chomp) rescue nil
  unless id && estudiantes.key?(id)
    puts "No existe un estudiante con ese ID."
    return
end
nombre = estudiantes[id][:nombre]
puts "Ingresando notas para #{nombre}:"
notas = []
3.times do |i|
  loop do
    print "Nota #{i + 1} (0.00 - 100.00):"
    input = gets.chomp
    nota = Float (input) rescue nil
    if nota && nota >= 0.0 && nota <= 100.0
      notas << nota
      break
    else
      puts "Por favor, ingrese un número entre 0.00 y 100.00"
    end
  end
end
estudiantes[id][:notas] = notas
puts "Notas registradas: #{notas.map { |n| format ('%.2f', n) }.join(', ')}"
end

#Método para calcular promedio ---------------
def calcular_promedio(estudiantes)
  return nil if notas.empty?
  notas.sum / notas.size.to_f
end
#Método para consultar el promedio
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


#Método para listar a todos los estudiantes -------------
def listar_estudiantes(estudiantes)
  if estudiantes.empty?
    puts "No hay estudiantes registrados."
    return
  end
  puts "ID | Nombre | Promedio"
  puts "-------------------------------"
  estudiantes.sort.each do |id, info|
    prom = calcular_promedio(info[:notas])
    prom_texto = prom ? format('%2f', prom) : "N/A"
    puts "#{id} | #{info[:nomre]} | #{prom_texto}"
  end
end

#Inicio de la función principal ----------------------

#Pendiente


def guardar_y_salir(estudiantes)
  puts "[Guardar y salir] = pendiente implementación"
end

#Bucle principal del menú
loop do
  mostrar_menu
  input = gets.chomp

#Validación básica, revisa que sea entero positivo
if input =~ /^\s*\d+\s*$/
  opcion = input.to_i
else
  puts "Entrada inválida: ingresa el número de la opción."
  next
end

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
  puts "Saliendo... ¡Hasta luego!"
  break
else
    puts "Opción inválida. Elige entre 1 y 5."
  end
end

