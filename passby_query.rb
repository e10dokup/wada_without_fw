Dir[File.expand_path('../models', __FILE__) << '/*.rb'].each do |file|
  require file
end

def get_matching(passings, user, passed_with)
  data = []
  passings.each do |passing|
    time = passing.passing_at.strftime("%Y/%m/%d %H:%M")
    object = User.find_by(ble_uid: passing.object_address)
    subject = User.find_by(ble_uid: passing.subject_address)
    unless user = ""
      if object.nil? || user != object.name
        next
      end
    end
    if passed_with == ""
      if subject.nil?
        subject = User.new
        subject.name = "unknown"
      end
    else
      if subject.nil? || passed_with != subject.name
        next
      end
    end
    data.push({passby: passing, time: time, subject: subject.name})
  end

  data
end