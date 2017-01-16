class RankingController < ApplicationController
  def have
    @title = 'Haveランキング'
    have_rank =  Have.group(:item_id).order('count_all desc').limit(10).count

    @items = Item.find(have_rank.keys).sort_by{ |o| have_rank.keys.index(o.id) }
    @ranks = have_rank.values
    render 'ranking'
  end

  def want
    @title = 'Wantランキング'
    #Want.group(:item_id).count()でitem_idごとの数を検索可能
    # limit(最大取得行数)でレコード件数を指定
    want_rank =  Want.group(:item_id).order('count_all desc').limit(10).count.keys
    
    @items = Item.find(want_rank).sort_by{ |o| want_rank.index(o.id) }

    @ranks =  Want.group(:item_id).order('count_item_id desc').limit(10).count('item_id').values
    render 'ranking'
  end
end

