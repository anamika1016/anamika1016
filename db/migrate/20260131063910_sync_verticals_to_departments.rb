class SyncVerticalsToDepartments < ActiveRecord::Migration[8.0]
  def up
    # Sync verticals from EmployeeDetail to Department
    verticals = EmployeeDetail.distinct.pluck(:department).compact

    verticals.each do |v|
      # Normalize and Clean
      normalized_v = v.strip

      # Handle specific cleanups
      case normalized_v.downcase
      when 'hod'
        normalized_v = 'HOD'
      when 'finace'
        normalized_v = 'Finance'
      when 'finance'
        normalized_v = 'Finance'
      end

      # Ensure department exists
      Department.find_or_create_by!(department_type: normalized_v)
    end

    # Update employee records to match normalized names if necessary
    EmployeeDetail.where(department: 'hod').update_all(department: 'HOD')
    EmployeeDetail.where(department: 'Finace').update_all(department: 'Finance')
  end

  def down
    # No undo for data migrations usually, or we could delete the created departments
    # but that might be destructive if they have activities now.
  end
end
