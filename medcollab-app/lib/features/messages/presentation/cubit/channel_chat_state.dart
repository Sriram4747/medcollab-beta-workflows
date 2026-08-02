part of 'channel_chat_cubit.dart';

class ChannelChatState extends Equatable {
  const ChannelChatState({
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.isUploading = false,
    this.hasMore = false,
    this.error,
    this.typingUserNames = const [],
  });

  final List<MessageModel> messages;
  final bool isLoading;
  final bool isSending;
  final bool isUploading;
  final bool hasMore;
  final String? error;
  final List<String> typingUserNames;

  String get typingLabel {
    final names = typingUserNames;
    if (names.isEmpty) return '';
    if (names.length == 1) return '${names.first} is typing…';
    if (names.length == 2) return '${names[0]} and ${names[1]} are typing…';
    return '${names.length} people are typing…';
  }

  ChannelChatState copyWith({
    List<MessageModel>? messages,
    bool? isLoading,
    bool? isSending,
    bool? isUploading,
    bool? hasMore,
    String? error,
    List<String>? typingUserNames,
  }) {
    return ChannelChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      isUploading: isUploading ?? this.isUploading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      typingUserNames: typingUserNames ?? this.typingUserNames,
    );
  }

  @override
  List<Object?> get props => [
        messages,
        isLoading,
        isSending,
        isUploading,
        hasMore,
        error,
        typingUserNames,
      ];
}
