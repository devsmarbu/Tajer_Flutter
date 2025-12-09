class CreditsListingItem {
  String? utxnDate;
  String? utxnType;
  String? utxnStatusLabel;
  String? utxnOrderId;
  String? txnPaymentType;
  String? utxnCredit;
  String? balance;
  String? utxnUserId;
  String? utxnOpId;
  String? utxnWithdrawalId;
  String? utxnDebit;
  String? utxnId;
  String? utxnStatus;
  String? utxnComments;
  String? utxnGatewayTxnId;

  CreditsListingItem({
    this.utxnDate,
    this.utxnType,
    this.utxnStatusLabel,
    this.utxnOrderId,
    this.txnPaymentType,
    this.utxnCredit,
    this.balance,
    this.utxnUserId,
    this.utxnOpId,
    this.utxnWithdrawalId,
    this.utxnDebit,
    this.utxnId,
    this.utxnStatus,
    this.utxnComments,
    this.utxnGatewayTxnId,
  });

  factory CreditsListingItem.fromJson(Map<String, dynamic> json) {
    return CreditsListingItem(
      utxnDate: json['utxn_date'],
      utxnType: json['utxn_type'],
      utxnStatusLabel: json['utxn_statusLabel'],
      utxnOrderId: json['utxn_order_id'],
      txnPaymentType: json['txnPaymentType'],
      utxnCredit: json['utxn_credit'],
      balance: json['balance'],
      utxnUserId: json['utxn_user_id'],
      utxnOpId: json['utxn_op_id'],
      utxnWithdrawalId: json['utxn_withdrawal_id'],
      utxnDebit: json['utxn_debit'],
      utxnId: json['utxn_id'],
      utxnStatus: json['utxn_status'],
      utxnComments: json['utxn_comments'],
      utxnGatewayTxnId: json['utxn_gateway_txn_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'utxn_date': utxnDate,
      'utxn_type': utxnType,
      'utxn_statusLabel': utxnStatusLabel,
      'utxn_order_id': utxnOrderId,
      'txnPaymentType': txnPaymentType,
      'utxn_credit': utxnCredit,
      'balance': balance,
      'utxn_user_id': utxnUserId,
      'utxn_op_id': utxnOpId,
      'utxn_withdrawal_id': utxnWithdrawalId,
      'utxn_debit': utxnDebit,
      'utxn_id': utxnId,
      'utxn_status': utxnStatus,
      'utxn_comments': utxnComments,
      'utxn_gateway_txn_id': utxnGatewayTxnId,
    };
  }
}