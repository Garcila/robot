class Robot

	CAPACITY = 250
	MINIMUM_ALLOWED_HEALTH = 0
	MAXIMUM_ALLOWED_HEALTH = 100

	attr_reader :x, :y, :items, :items_weight, :health
	attr_accessor :equipped_weapon
	
	def initialize(x=0, y=0)
		@x = x
		@y = y
		@items = []
		@items_weight = 0
		@health = 100
		@equipped_weapon = nil
	end	

	def position
		[@x,@y]
	end

	def move_left
		@x -= 1
	end

	def move_right
		@x += 1
	end

	def move_up
		@y += 1
	end

	def move_down
		@y -= 1
	end

	def pick_up(item)
		if item.is_a?(BoxOfBolts) && health <= 80
			item.feed(self)
		else
			if item.is_a? Weapon
					@equipped_weapon = item
			else 
				if items_weight + item.weight <= CAPACITY
					@items << item
				end
			end
		end
	end

	def items_weight
		@items.inject(0) {|sum,item| sum + item.weight}
	end

	def wound(damage)
		if @health - damage > MINIMUM_ALLOWED_HEALTH
			@health -= damage
		else
			@health = MINIMUM_ALLOWED_HEALTH
		end
	end

	def heal(recover)
		if @health + recover <= MAXIMUM_ALLOWED_HEALTH
			@health += recover
		else
			@health = MAXIMUM_ALLOWED_HEALTH
		end
	end

	def equipped_grenade?
		self.equipped_weapon.is_a? Grenade
	end

	def in_grenade_range?(robot)
		((robot.position[1]-2 || robot.position[1]+2) - self.position[1]) == 0
	end

	def attack_with_grenade(robot)
		equipped_weapon.hit(robot) if in_grenade_range?(robot)
		self.equipped_weapon = nil
	end

	def with_one_range?(robot)
		# binding.pry
		robot.position[1]-1 == position[1] || robot.position[1]+1 == position[1] || robot.position == position
	end

	def attack(robot)
		if equipped_grenade?
			attack_with_grenade(robot)
		else
			if with_one_range?(robot)
				if equipped_weapon != nil
					equipped_weapon.hit(robot)
				else
			 		robot.wound(5)
			 	end
			else
			 	false
			end
		end
	end
end