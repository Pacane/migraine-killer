List<String> questions = [
  "Je me sens calme",
  "Je me sens en sécurité",
  "Je suis tendu(e)",
  "Je me sens surmené(e)",
  "Je me sens tranquille",
  "Je me sens bouleversé",
  "Je suis préoccupé(e) actuellement par des malheurs possibles",
  "Je me sens comblé(e)",
  "Je me sens effrayé(e)",
  "Je me sens à l’aise",
  "Je me sens sûr de moi",
  "Je me sens nerveux(se)",
  "Je suis affolé(e)",
  "Je me sens indécis(e)",
  "Je suis détendu(e)",
  "Je me sens satisfait(e)",
  "Je suis préoccupé(e)",
  "Je me sens tout mêlé(e)",
  "Je sens que j’ai les nerfs solides",
  "Je me sens bien",
];

class AnswerUpdate {
  final String question;
  final int answer;

  AnswerUpdate(this.question, this.answer);
}
