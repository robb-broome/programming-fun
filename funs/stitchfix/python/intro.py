class UsefulThing:
  some_class_var = 'class var'
  """ some comment """
  def __init__(self, thing):
      self.thing = thing

  def say(self):
    print("i am saying", self.thing)


a = UsefulThing('hello')
a.say()
print(a.some_class_var)


b = UsefulThing("goodbye")
b.say()
print(b.some_class_var)

