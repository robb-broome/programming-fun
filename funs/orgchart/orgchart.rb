# quick solution
#
def people
  @people ||= begin
                raw_people =  "3:robb:1,2:todd:1,1:dad:0,4:jon:3"
                raw_people.split(',').map {|raw_person| raw_person.split(":")}
              end
end

def top
  all_ids = people.map(&:first)
  top_person = people.select do |id, name, boss|
    !all_ids.include?(boss)
  end.first
  top_person
end

def print(person, level)
  boss_id, boss_name, _ = person
  puts "#{'-' * level} #{boss_name} (id: #{boss_id})"
  reports = people.select do |person_id, name, person_boss_id|
    person_boss_id == boss_id
  end
  return if reports == []
  reports.each {|report| print(report, level + 1)}
end

print(top, 1)
