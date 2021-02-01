# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Collab.create(yt_id: 'RY_Q2T1Tg2k') # Hoshi no Dialogue
Collab.create(yt_id: 'z0yKFwx8XQk') # Xtreme Vibes
Collab.create(yt_id: 'uFDw0D4AaRY') # TftMN
hnd = Collab.find_by(yt_id: 'RY_Q2T1Tg2k')
xv = Collab.find_by(yt_id: 'z0yKFwx8XQk')
tftmn = Collab.find_by(yt_id: 'uFDw0D4AaRY')

Person.create(yt_link: '/user/xXxAngelOfYouthxXx')
Person.create(yt_link: '/user/sepiadayscom')
Person.create(yt_link: '/lynsings')
joy = Person.find_by(yt_link: '/user/xXxAngelOfYouthxXx')
mathew = Person.find_by(yt_link: '/user/sepiadayscom')
lyn = Person.find_by(yt_link: '/lynsings')

# roles: [0 = anim, 1 = art, 2 = mix, 3 = vocal]
Role.create(collab_id: hnd.id, person_id: mathew.id, role: :mix)
Role.create(collab_id: hnd.id, person_id: joy.id, role: :vocal)
Role.create(collab_id: hnd.id, person_id: lyn.id, role: :vocal)

Role.create(collab_id: xv.id, person_id: joy.id, role: :vocal)

Role.create(collab_id: tftmn.id, person_id: lyn.id, role: :vocal)
Role.create(collab_id: tftmn.id, person_id: lyn.id, role: :anim)