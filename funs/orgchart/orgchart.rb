require 'faker'
require 'pry'

USE_RANDOM = false

def raw_data
  "3:robb:1,2:todd:1,1:dad:0,4:jon:3,5:jonson:4"
end

class Employee
  @@all_employees = {}
  @@max_level = 3 
  @@employee_id_counter = 0
  @@number_of_reports_range = (1..3)

  class << self
    def add(employee)
      @@all_employees[employee.id] = employee.raw
    end

    def all_employees
      @@all_employees
    end

    def find(id)
      all_employees[id]
    end

    def big_boss
      all_employees.select do |_employee_id, employee|
        find(employee.boss_id).nil?
      end.value
    end

    def random_reports_count
      rand(@@number_of_reports_range)
    end

    def make_employees(boss=nil, level=0)
      return if level >= @@max_level
      boss ||= Employee.new(id: 0, boss_id: -1)
      puts boss.raw
      random_reports_count.times.map do |employee_of_boss|
        employee = Employee.new(boss_id: boss.id)
        puts employee.raw
        add employee
        make_employees(employee.boss, level + 1)
      end
    end

    def generate_unique_ee_id
      @@employee_id_counter += 1
    end
  end

  attr_reader :id, :name, :boss_id
  def initialize(id: nil, name: nil, boss_id:)
    @id ||= Employee.generate_unique_ee_id
    @name ||= Faker::Name.name
    @boss_id = boss_id
  end

  def boss
    self.class.all_employees[boss_id]
  end

  def raw
    "#{id}:#{name}:#{boss_id}"
  end

end


# naive stuff
def people
  @people ||= begin
                raw_data.split(',').map {|raw_person| raw_person.split(":")}
              end
end

def all_ids
  @all_ids ||= people.map(&:first)
end

def top
  top_person = people.select do |id, name, boss|
    !all_ids.include?(boss)
  end.first
  top_person
end

def print_org_chart(person, level)
  boss_id, boss_name, _ = person
  puts "#{'-' * level} #{boss_name} (id: #{boss_id})"
  reports = people.select do |person_id, name, person_boss_id|
    person_boss_id == boss_id
  end
  return if reports == []
  reports.each {|report| print_org_chart(report, level + 1)}
end

RSpec.describe 'it' do
  it 'wlao works' do
   Employee.make_employees
   puts Employee.big_boss
  end

  it 'works' do
    print_org_chart(top, 1)
  end
end
