require 'xcodeproj'

PROJ_PATH = '/Users/maxiao/Desktop/demo/swiftUILearn/swiftUILearn/swiftUILearn.xcodeproj'
SOURCE_ROOT = '/Users/maxiao/Desktop/demo/swiftUILearn/swiftUILearn/swiftUILearn'

project = Xcodeproj::Project.open(PROJ_PATH)
target = project.targets.find { |t| t.name == 'swiftUILearn' }
main_group = project.main_group['swiftUILearn']

# 需要添加的目录（相对于 SOURCE_ROOT）
dirs_to_add = {
  'Models'             => ['Models/Lesson.swift'],
  'Resources'          => ['Resources/LessonData.swift'],
  'Main'               => ['Main/SharedComponents.swift'],
  'Chapters/01_Basics' => Dir.glob("#{SOURCE_ROOT}/Chapters/01_Basics/*.swift").map { |f| f.sub("#{SOURCE_ROOT}/", '') },
  'Chapters/02_Layout' => Dir.glob("#{SOURCE_ROOT}/Chapters/02_Layout/*.swift").map { |f| f.sub("#{SOURCE_ROOT}/", '') },
  'Chapters/03_State'  => Dir.glob("#{SOURCE_ROOT}/Chapters/03_State/*.swift").map { |f| f.sub("#{SOURCE_ROOT}/", '') },
  'Chapters/04_Navigation' => Dir.glob("#{SOURCE_ROOT}/Chapters/04_Navigation/*.swift").map { |f| f.sub("#{SOURCE_ROOT}/", '') },
  'Chapters/05_List'   => Dir.glob("#{SOURCE_ROOT}/Chapters/05_List/*.swift").map { |f| f.sub("#{SOURCE_ROOT}/", '') },
  'Chapters/06_Animation' => Dir.glob("#{SOURCE_ROOT}/Chapters/06_Animation/*.swift").map { |f| f.sub("#{SOURCE_ROOT}/", '') },
  'Chapters/07_Persistence' => Dir.glob("#{SOURCE_ROOT}/Chapters/07_Persistence/*.swift").map { |f| f.sub("#{SOURCE_ROOT}/", '') },
}

# 移除旧的 ContentView（将用新的替换）
# 确保 ContentView.swift 已经更新（它已经在项目中）

def find_or_create_group(parent, path_components)
  group = parent
  path_components.each do |component|
    existing = group.children.find { |c| c.is_a?(Xcodeproj::Project::Object::PBXGroup) && c.name == component }
    if existing
      group = existing
    else
      group = group.new_group(component, component)
    end
  end
  group
end

dirs_to_add.each do |dir_path, files|
  components = dir_path.split('/')
  group = find_or_create_group(main_group, components)

  files.each do |relative_path|
    file_path = "#{SOURCE_ROOT}/#{relative_path}"
    file_name = File.basename(file_path)

    # 检查是否已存在
    existing = group.children.find { |c| c.is_a?(Xcodeproj::Project::Object::PBXFileReference) && c.path == file_name }
    next if existing

    file_ref = group.new_file(file_path)
    target.source_build_phase.add_file_reference(file_ref)
    puts "Added: #{relative_path}"
  end
end

project.save
puts "\n✅ 项目文件更新完成！"
