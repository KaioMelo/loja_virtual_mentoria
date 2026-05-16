package br.com.lojavirtual.enums;

public enum StatusContaReceber {
	
	COBRANCA("paga"),
	VENCIDA("vencida"),
	ABERTA("aberta"),
	QUITADA("quitada");
	
	private String descricao;
	
	private StatusContaReceber(String descricao) {
		this.descricao = descricao;
	}

	public String getDescricao() {
		return descricao;
	}

}
