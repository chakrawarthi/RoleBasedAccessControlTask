# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create!(name: "Admin",   email: "admin@test.com",   role: "admin")
User.create!(name: "Manager", email: "manager@test.com", role: "manager")
User.create!(name: "Manager_2", email: "manager_2@test.com", role: "manager")
User.create!(name: "Manager_3", email: "manager_3@test.com", role: "manager")
User.create!(name: "Manage_4", email: "manager_4@test.com", role: "manager")
User.create!(name: "Member_2",  email: "membe_2@test.com",  role: "member")
User.create!(name: "Member_3",  email: "member_3@test.com",  role: "member")
User.create!(name: "Member_4",  email: "member_4@test.com",  role: "member")
User.create!(name: "Member_5",  email: "member_5@test.com",  role: "member")
User.create!(name: "Member_6",  email: "member_6@test.com",  role: "member")
User.create!(name: "Member_7",  email: "member_7@test.com",  role: "member")
User.create!(name: "Member_8",  email: "member_8@test.com",  role: "member")
User.create!(name: "Member_9",  email: "member_9@test.com",  role: "member")