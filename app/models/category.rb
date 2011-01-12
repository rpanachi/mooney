class Category < ActiveRecord::Base

  DEFAULT_CATEGORIES = [
    ["Receitas", ["Salários", "Rendimentos", "Depósitos / créditos", "Empréstimos", "Outros"]],
    ["Impostos", ["Imposto de Renda", "IPTU", "IPVA", "Tarifas bancárias", "Honorários contábeis", "Outros"]],
    ["Investimentos", ["Aplicação em poupança", "Ações / fundos", "Previdência privada", "Outros"]],
    ["Educação", ["Cursos / especialização", "Escola / faculdade", "Livros / revistas", "Outros"]],
    ["Moradia", ["Supermercado", "Telefone fixo ", "Água e esgoto", "Energia elétrica", "Aluguel / prestação", "Condomínio", "Doméstica / diarista", "TV / internet", "Serviços / manutenção", "Outros"]],
    ["Lazer", ["Bares / restaurantes", "Cinema / shows", "Jogos / hobbies", "Academia / esportes", "Viagens", "Outros"]],
    ["Pessoal", ["Restaurantes / padarias", "Telefone celular", "Cosméticos", "Vestuário", "Outros"]],
    ["Saúde", ["Consultas / exames", "Farmácia / remédios", "Plano de saúde", "Outros"]],
    ["Veículos", ["Táxi / metrô / ônibus", "Pedágios", "Combustível", "Estacionamento", "Manutenção", "Prestação", "Seguros", "Multas", "Outros"]],
    ["Diversos", ["Presentes", "Doações / contribuições", "Outros"]]
  ]

  belongs_to :user
  has_many :entries

  belongs_to :parent, :class_name => name, :foreign_key => :parent_id
  has_many :children, :class_name => name, :foreign_key => :parent_id, :order => :position, :dependent => :destroy

  named_scope :from_user, lambda { |user|
    { :conditions => { :user_id => user.id } }
  }

  named_scope :roots, lambda {
    { :conditions => ["parent_id = ?", 0], :order => :position }
  }

  #root categories with balance
  #Category.from_user(User.first).roots(:joins => [:entries], :group => "categories.name", :select => "categories.name, sum(entries.value) as balance", :conditions => "entries.id in (select child.id from categories child where parent_id = entries.category_id) and entries.paid")

  validates_presence_of :user
  validates_length_of :name, :within => 3..30
  validate :category_hierarchy
  validate :categories_limit

  after_create :reorder
  after_destroy :destroy_children, :reorder

  def self.can_create?(user)
    Category.from_user(user).count < 80
  end

  def categories_limit
    errors.add_to_base("Limite de 80 categorias por usuário atingido!") if new_record? && !Category.can_create?(user)
  end

  def root?
    !parent
  end

  def move_up
    update_attribute(:position, (position || 0) - 1)
    reorder(:desc)
  end

  def move_down
    update_attribute(:position, (position || 0) + 1)
    reorder(:asc)
  end

  def balance
    balance_in_month(Date.today)
  end

  def balance_in_month(date = Date.today)
    conditions = root? ? ["category_id in (?) and paid", children.collect {|c| c.id}] : ["category_id = ? and paid", id]
    Entry.from_user(user).in_month(date).sum(:value, :conditions => conditions)
  end

  def pending
    pending_in_month(Date.today)
  end

  def pending_in_month(date = Date.today)
    conditions = root? ? ["category_id in (?) and not paid", children.collect {|c| c.id}] : ["category_id = ? and not paid", id]
    Entry.from_user(user).in_month(date).sum(:value, :conditions => conditions)
  end

  private

  def reorder(order = :asc)
    categories_to_order = (root? ? Category.from_user(user).roots : parent.children).find(:all, :order => "position, updated_at #{order}")
    categories_to_order.each_with_index do |category, index|
      category.update_attribute(:position, index)
    end
  end

  def destroy_children
    children.destroy_all if !children.empty?
  end

  def category_hierarchy
    errors.add_to_base("Uma categoria não pode ter mais de dois níveis.") if !root? && !children.empty?
    errors.add_to_base("Uma categoria não pode ser subcategoria dela mesma.") if parent && parent.id == id
  end

end
