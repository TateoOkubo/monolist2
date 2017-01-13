class Want < Ownership
  belongs_to :user
  belongs_to :item
  
  #Want.group(:item_id).count()でitem_idごとの数を検索可能
  
end
