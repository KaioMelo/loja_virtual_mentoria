package br.com.lojavirtual.service;

import org.springframework.stereotype.Service;

import br.com.lojavirtual.model.Acesso;
import br.com.lojavirtual.repository.AcessoRepository;

@Service
public class AcessoService {

	private final AcessoRepository acessoRepository;
	
	public AcessoService(AcessoRepository acessoRepository) {
		this.acessoRepository = acessoRepository;
	}
	
	public Acesso save(Acesso acesso) {
		return acessoRepository.save(acesso);
	}
	
	public void delete(Long idAcesso) {
		acessoRepository.deleteById(idAcesso);
	}
}
