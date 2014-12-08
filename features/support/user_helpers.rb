module UserHelpers
  def doctor_who
    @doctor_who ||= create :user, email: 'dr_who@sjsu.edu'
  end
end
