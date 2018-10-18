class JobsController < ApplicationController

  # ログイン済みのユーザーのみ閲覧可能。（showページ以外）
  before_action :authenticate_user!, except: :show

  def index
  end

  def new
    @job = Job.new
  end

  def create
    #job_paramsの値が入ったオブジェクトを作成する
    @job = Job.new(job_params)
    #テキストを書き込みための画像を読み込む
    image = Magick::ImageList.new('./public/base_image.png')
    #画像に線や文字を描画するDrawオブジェクトの生成
    draw = Magick::Draw.new
    #cut_textの処理結果をtitleに代入
    title = cut_text(@job.title)

    #文字の描画（引数は、画像、幅、高さ、X座標、Y座標、描画する文字）
    draw.annotate(image, 0, 0, 0, -120, title) do
      #日本語対応可能なフォントにする
      self.font = 'app/assets/NotoSansJP-Bold.otf'
      #フォントの塗りつぶし色
      self.fill = '#fff'
      #描画基準位置(中央)
      self.gravity = Magick::CenterGravity
      #フォントの太さ
      self.font_weight = Magick::BoldWeight
      #フォント縁取り色(透過)
      self.stroke = 'transparent'
      #フォントサイズ（48pt）
      self.pointsize = 48
    end

    #もし求人が保存できたら
    if @job.save
      #フラッシュメッセージを出す
      flash[:notice] = "求人が保存されました"
      #作成された求人の詳細ページへリダイレクト
      redirect_to @job
    else
      #保存できない場合
      flash[:alert] = "募集作成に失敗しました"
    end
  end

  def show
    @job = Job.find(params[:id])
  end

private

  #/./public/以下を""に切り取る
  def cut_path(url)
    url.sub(/\.\/public\//, "")
  end

  #.piblic/ランダムな文字列/.pngというファイル名に加工する
  def uniq_file_name
    "./public/#{SecureRandom.hex}.png"
  end

  #15文字ごとに改行を入れる
  def cut_text(text)
      text.scan(/.{1,15}/).join("\n")
  end


  def job_params
    params.require(:job).permit(:title, :content).merge(user_id: current_user.id)
  end



end
