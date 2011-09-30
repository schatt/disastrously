# Copyright 2011 Redpill-Linpro AS.
#
# This file is part of Disastrously.
#
# Disastrously is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# Disastrously is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# Disastrously. If not, see <http://www.gnu.org/licenses/>.

# This file is loaded after schema.rb during a rake db:schema:load. It is not
# autogenerated, so you can safely edit this file. It exists to add extra
# modifications to the database that db:schema:dump does not create
# automatically for us (e.g. foreign keys).
#
# Do not add things here without also adding it to a migration!
#
# The reverse is also true: If you add anything to a migration that doesn't
# show up in the schema.rb file (typically if you run custom SQL via execute)
# you must remember to put it here as well!
#
# Failure to do so will make new databases (e.g. development bases and the
# database used when running tests) inconsistent with current running /
# production systems.
ActiveRecord::Schema.define do

  # Migration 023: Create foreign keys:
  add_foreign_key :user,            :user_type
  add_foreign_key :user_membership, :user
  add_foreign_key :historie,        :user
  add_foreign_key :historie,        :incident
  add_foreign_key :incident,        :severitie, :severity_id

  # Migration 028: Make user id non incremental:
  execute %{ALTER TABLE users ALTER COLUMN id SET DEFAULT NULL;}

  # Migration 025: Make groups id string:
  # Change group id to a unique string. This is needed for LDAP
  # synchronisation.
  change_column :groups, :id, :string, :unique => true, :null => false

  # Migration 040: Add deferrable constraints:
  # Make sure the user and group tables actually marks the id-field as primary:
  execute %{ALTER TABLE groups ADD PRIMARY KEY (id);}

  #add_foreign_key :incident,          :group, :deferrable => true
  add_foreign_key :user_membership,   :group, :deferrable => true
  add_foreign_key :group_membership,  :group, :deferrable => true
  add_foreign_key :group_membership,  :group, :parent_id, :deferrable => true

  # Migration 20110530: Create Incident Timestamps:
  add_foreign_key :incident_timestamp, :incident, :cascade_delete => true

  # Migration 20110621: Incident Children: 
  add_foreign_key :incident, :incident, :parent_id, :deferrable => true, :cascade_delete => true
end