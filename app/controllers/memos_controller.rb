class MemosController < ApplicationController
  before_action :authenticate_request!

  # POST /api/memos
  def create
    return render_error(400, 2, 'content는 필수') unless content_present?

    memo = current_account.memos.create!(memo_param)

    memo_json = memo.as_json
    memo_json['contents'] = memo_json.delete('content')

    render_success 201, memo: memo_json
  end

  # GET /api/memos
  def index
    count = params[:count] || 6
    before_id = params[:before_id]
    memos = if before_id.present?
              current_account.memos.where('id < ?', before_id).order(id: :desc).limit(count)
            else
              current_account.memos.order(id: :desc).limit(count)
    end

    memos_json = memos.as_json.map do |memo_json|
      memo_json['contents'] = memo_json.delete('content')
      memo_json
    end

    render_success :ok, memos: memos_json
  end

  # DELETE /api/memos/:id
  def destroy
    return render_error 400, 1, 'id의 형식이 잘못됨' unless match_regex_id
    return render_error 422, 3, '해당 id에 대한 리소스가 없음' unless memo = find_memo
    return render_error 422, 4, '권한없음' unless memo.account_id == current_account.id

    memo.destroy!

    memo_json = memo.as_json
    memo_json['contents'] = memo_json.delete('content')

    render_success :ok, memo: memo_json
  end

  # PATCH /api/memos/:id
  def update
    return render_error 400, 1, 'id의 형식이 잘못됨' unless match_regex_id
    return render_error 422, 2, 'content는 필수' unless content_present?
    return render_error 422, 3, '해당 id에 대한 리소스가 없음' unless memo = find_memo
    return render_error 422, 4, '권한없음' unless memo.account_id == current_account.id

    memo.update(memo_param.merge(is_edited: true))

    memo_json = memo.as_json
    memo_json['contents'] = memo_json.delete('content')

    render status: 200, json: { memo: memo_json }
  end

  private

  def content_present?
    params[:content].present?
  end

  def match_regex_id
    /\d+/.match(params[:id].to_s)
  end

  def find_memo
    Memo.find_by(id: params[:id])
  end

  def memo_param
    {
      content: params[:contents]
    }
  end
end
