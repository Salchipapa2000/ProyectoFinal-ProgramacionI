FILE_NAME = 'estudiantes.txt'

estudiantes = {}

#Para poder cargar los datos en txt
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

#Metodo para guardar
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

#Mostrar menu principal
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

#Métodos en esqueleto
def registrar_estudiante(estudiantes)
  puts "[Registrar estudante] = pendiente implementación"
end

def ingresar_notas(estudiantes)
  puts "[Ingresar notas] = pendiente implementación"
end

def consultar_promedio(estudiantes)
  puts "[Consultar promedio] = pendiente implementación"
end

def listar_estudiantes(estudiantes)
  puts "[Guardar y salir] = pendiente implementación"
end

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

