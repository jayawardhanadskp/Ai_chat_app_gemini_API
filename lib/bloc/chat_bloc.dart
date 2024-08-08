import 'dart:async';

import 'package:ai_app/models/message_model.dart';
import 'package:ai_app/repos/chat_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatSucessState(messages: [])) {
    on<ChatGenerateNewTextMessageEvent>(chatGenerateNewTextMessageEvent);
  }

  List<ChatMessageModel> messages = [];
  bool genarating = false;

  FutureOr<void> chatGenerateNewTextMessageEvent(
      ChatGenerateNewTextMessageEvent event, Emitter<ChatState> emit) async {
    messages.add(ChatMessageModel(
        role: 'user', parts: [ChatPartModel(text: event.inputMessage)]));
    emit(ChatSucessState(messages: messages));
    genarating = true;
    String genaratedText = await ChatRepo.chatTextGenerationRepo(messages);
    if (genaratedText.length > 0) {
      messages.add(ChatMessageModel(
          role: 'model', parts: [ChatPartModel(text: genaratedText)]));
      emit(ChatSucessState(messages: messages));
      genarating = false;
    }
  }
}
