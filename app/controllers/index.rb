get '/' do
  erb :index
end

get '/create_survey/:id' do |id|
	@user = User.find(id)
	erb :create_survey
end

post '/create_survey/:id' do
	@survey = Survey.create(params[:user])
	redirect "/make_questions/#{@survey.id}"
end 

get '/make_questions/:id' do |id|
	@survey = Survey.find(id)
	erb :make_questions
end

post '/make_questions/:id' do |id|
	@survey = Survey.find(id)
	params[:survey].each do |question|
		q_title = question["title"] #q1
		ques = Question.create(question: q_title)
		@survey.questions << ques
		q_answers = question["answers"] # [a1, a2]
		q_answers.each do |answer|
			ans = Answer.create(answer: answer)
			ques.answers << ans
		end
	end
	redirect '/dashboard'
end

get '/dashboard' do
  if current_user
    @surveys = Survey.all
    @surveys_answered = @user.surveys
    erb :dashboard
  else
    redirect '/'
  end
end

get '/create_survey/:id' do |id|
  erb :create_survey
end

get '/take_survey/:id' do
    @survey = Survey.find(params[:id])  # remove this stuff and put into take_survey post
    @question_bank = @survey.questions
    @answer_bank = @survey.questions.first.answers
    erb :take_survey
end


post '/survey_submit' do 

  survey_id = params.shift.pop
  p survey_id
  p params
  if params
    params.values.each do |answer_id|
      Response.create(user_id: session[:user_id], survey_id: survey_id,  answer_id: answer_id)
      redirect '/dashboard'
    end
  else
    redirect '/take_survey/#{:id}'
  end
end

# User.first.surveys.first.questions.first.answers.first.responses
