require 'pg'

class Database
  def initialize
    @db = connect_to_database
  end
  
  def disconnect
    db.close
  end
  
  def query(statement, *params)
    db.exec_params(statement, params)
  end
  
  def get_projects
    sql = <<~SQL
      SELECT id, name, project_status FROM projects;
    SQL
    
    result = query(sql)
    
    result.map do |row|
      { id: row['id'], name: row['name'], status: row['project_status'] }
    end
  end
  
  def get_project_info(id)
    sql = <<~SQL
      SELECT * FROM projects WHERE id = $1;
    SQL
    
    result = query(sql, id)
    
    result.map do |row|
      {
        id: row['id'], name: row['name'], yarn: row['yarn'], colors: row['colors'],
        weight: row['weight'], for: row['making_for'], pattern: row['pattern'],
        link: row['pattern_link'], hook: row['hook'], image: row['image'],
        date_added: format_date(row['date_added']), status: row['project_status'],
        notes: row['notes']
      }
    end
  end
  
  def new_project(name, yarn, colors, weight, making_for, pattern, pattern_link, hook, status, notes)
    sql = <<~SQL
      INSERT INTO projects (name, yarn, colors, weight, making_for, pattern, pattern_link, hook, project_status, notes) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);
    SQL
    
    query(sql, name, yarn, colors, weight, making_for, pattern, pattern_link, hook, status, notes)
  end
  
  def update_project(id, name, yarn, colors, weight, making_for, pattern, pattern_link, hook, status, notes)
    sql = <<~SQL
      UPDATE projects SET name = $2, yarn = $3, colors = $4, weight = $5, making_for = $6,
      pattern = $7, pattern_link = $8, hook = $9, project_status = $10, notes = $11
      WHERE id = $1;
    SQL
    
    query(sql, id, name, yarn, colors, weight, making_for, pattern, pattern_link, hook, status, notes)
  end
  
  def set_project_complete(id)
    sql = "UPDATE projects SET project_status = 'Finished' WHERE id = $1"
    query(sql, id)
  end
  
  def delete_project(id)
    sql = "DELETE FROM projects WHERE id = $1"
    query(sql, id)
  end
  
  def update_project_image(id, path)
    sql = "UPDATE projects SET image = $2 WHERE id = $1"
    query(sql, id, path)
  end
  
  def update_pattern(id, pattern)
    sql = "UPDATE projects SET pattern = $2 WHERE id = $1"
    query(sql, id, pattern)
  end
  
  def update_notes(id, notes)
    sql = "UPDATE projects SET notes = $2 WHERE id = $1"
    query(sql, id, notes)
  end
  
  private #-----------------------------------------------------------------------------------------
  
  attr_reader :db
  
  def connect_to_database
    if Sinatra::Base.production?
      PG.connect(ENV['DATABASE_URL'])
    else
      PG.connect(dbname: "mesa_test")
    end
  end
  
  def format_date(date)
    date.split(' ').first
  end
end