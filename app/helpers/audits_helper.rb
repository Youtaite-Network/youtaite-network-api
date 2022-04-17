module AuditsHelper
  def undo_changes_by_user user_id
    Audited.audit_class.as_user(User.find_by(alt_user_id: 'auditor')) do
      Audit.where(user_id: user_id).each do |audit|
        # todo: what would happen if other changes depend on this user's actions?
        #  (eg, because of FK constraints)
        # todo: what order are the audits undone?
        audit.undo
      end
    end
  end
end