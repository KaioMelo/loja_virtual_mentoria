package br.com.lojavirtual.enums;

public enum StatusContaPagar {
	
	COBRANCA("paga"),
	VENCIDA("vencida"),
	ABERTA("aberta"),
	QUITADA("quitada"),
	ALUGUEL("aluguel"),
	FUNCIONARIO("funcionario"),
	NEGOCIADA("renegociada");
	
	private String descricao;
	
	private StatusContaPagar(String descricao) {
		this.descricao = descricao;
	}

	public String getDescricao() {
		return descricao;
	}

}
