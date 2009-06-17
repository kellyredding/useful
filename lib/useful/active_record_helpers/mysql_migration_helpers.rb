module Useful
  module ActiveRecordHelpers
    module MysqlMigrationHelpers
      
      module ClassMethods

        def foreign_key(from_table, from_column, to_table, opts={})
          opts[:destination_key] = 'id' unless opts[:destination_key]
          constraint_name = "fk_#{from_table}_#{from_column}"
          execute %{alter table #{from_table}
                    add constraint #{constraint_name}
                    foreign key (#{from_column})
                    references #{to_table}(#{opts[:destination_key]})}
        end

        def drop_foreign_key(from_table, *from_columns)
          from_columns.each { |from_column|
            constraint_name = "fk_#{from_table}_#{from_column}"
            execute %{alter table #{from_table} drop FOREIGN KEY #{constraint_name}}
          }
        end

        def remove_column_with_fk(table, column)
          drop_foreign_key(table, column)
          remove_column(table, column)
        end

        def safe_drop_table(table_name)
          execute "drop table if exists #{table_name}"
        end

        def unique_constraint(table_name, columns)
          execute %{ALTER TABLE #{table_name} ADD CONSTRAINT uniq_#{columns.join('_')} UNIQUE KEY (#{columns.join(", ")})}
        end

        def set_auto_increment(table, number)
          execute %{ALTER TABLE #{table} AUTO_INCREMENT = #{number}}
        end

        def clear_table(table_to_clear)
          execute %{delete from #{table_to_clear}}
        end

        def create_view(view_name,sql_query_definition)
          execute %{
            CREATE SQL SECURITY INVOKER VIEW #{view_name.to_s} AS
            #{sql_query_definition}
          }
        end

        def drop_view(view_name)
          execute %{
            DROP VIEW #{view_name}
          }
        end

        def alter_view(view_name,sql_query_definition)
          execute %{
            ALTER SQL SECURITY INVOKER VIEW #{view_name.to_s} AS
            #{sql_query_definition}
          }
        end

      	def raise_err(msg = '')
      	  raise ActiveRecord::IrreversibleMigration, msg
      	end

      end
      
      module InstanceMethods
      end
      
      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end

    end
  end
end

module ActiveRecord
  class Migration
    include Useful::ActiveRecordHelpers::MysqlMigrationHelpers
  end
end
