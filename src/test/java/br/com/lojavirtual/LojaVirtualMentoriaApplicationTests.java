package br.com.lojavirtual;

import java.util.List;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Profile;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.DefaultMockMvcBuilder;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import br.com.lojavirtual.controlller.AcessoController;
import br.com.lojavirtual.model.Acesso;
import br.com.lojavirtual.repository.AcessoRepository;
//import br.com.lojavirtual.service.AcessoService;

@Profile("test")
@SpringBootTest(classes = LojaVirtualMentoriaApplication.class)
class LojaVirtualMentoriaApplicationTests {

//	@Autowired
//	private AcessoService acessoService;
	
	@Autowired
	private AcessoController acessoController;
	
	@Autowired
	private AcessoRepository acessoRepository;
	
	@Autowired
	private WebApplicationContext wac;
	
	@Test
	public void testRestApiCadastroAcesso() throws JsonProcessingException, Exception {
		
		DefaultMockMvcBuilder builder = MockMvcBuilders.webAppContextSetup(this.wac);
		MockMvc mockMvc = builder.build();
		
		Acesso acesso = new Acesso();
		
		acesso.setDescricao("ROLE_COMPRADOR");
		
		ObjectMapper objectMapper = new ObjectMapper();
		
		ResultActions retornoApi = mockMvc
				.perform(MockMvcRequestBuilders.post("/salvarAcesso")
				.content(objectMapper.writeValueAsString(acesso))
				.accept(MediaType.APPLICATION_JSON)
				.contentType(MediaType.APPLICATION_JSON));
		
		System.out.println("Retorno da API" + retornoApi.andReturn().getResponse().getContentAsString());
		
		/*Converter o retorno da API para um Objeto de acesso*/
		
		Acesso objetoRetorno = objectMapper.
				readValue(retornoApi.andReturn().getResponse().getContentAsString(),
				Acesso.class);
		
		Assertions.assertEquals(acesso.getDescricao(), objetoRetorno.getDescricao());
	}
	
	@Test
	public void testRestApiDeletePorIdAcesso() throws JsonProcessingException, Exception {
		
		DefaultMockMvcBuilder builder = MockMvcBuilders.webAppContextSetup(this.wac);
		MockMvc mockMvc = builder.build();
		
		Acesso acesso = new Acesso();
		
		acesso.setDescricao("ROLE_TESTE_DELETE_ID");
		
		acesso = acessoRepository.save(acesso);
		
		ObjectMapper objectMapper = new ObjectMapper();
		
		ResultActions retornoApi = mockMvc
				.perform(MockMvcRequestBuilders.delete("/deleteAcessoPorId/" + acesso.getId())
				.content(objectMapper.writeValueAsString(acesso))
				.accept(MediaType.APPLICATION_JSON)
				.contentType(MediaType.APPLICATION_JSON));
		
		System.out.println("Retorno da API" + retornoApi.andReturn().getResponse().getContentAsString());
		System.out.println("Status da API" + retornoApi.andReturn().getResponse().getStatus());
		
	}
	
	@Test
	public void testRestApiObterAcessoPorId() throws JsonProcessingException, Exception {
		
		DefaultMockMvcBuilder builder = MockMvcBuilders.webAppContextSetup(this.wac);
		MockMvc mockMvc = builder.build();
		
		Acesso acesso = new Acesso();
		
		acesso.setDescricao("ROLE_OBTER_ID");
		
		acesso = acessoRepository.save(acesso);
		
		ObjectMapper objectMapper = new ObjectMapper();
		
		ResultActions retornoApi = mockMvc
				.perform(MockMvcRequestBuilders.get("/obterAcessoPorId/" + acesso.getId())
				.content(objectMapper.writeValueAsString(acesso))
				.accept(MediaType.APPLICATION_JSON)
				.contentType(MediaType.APPLICATION_JSON));
		
		Assertions.assertEquals(200, retornoApi.andReturn().getResponse().getStatus());
		
		Acesso acessoRetorno = objectMapper.readValue(retornoApi.andReturn().getResponse().getContentAsString(), Acesso.class);
		
	}
	
	@Test
	public void testRestApibuscarAcessoPorDesc() throws JsonProcessingException, Exception {
		
		DefaultMockMvcBuilder builder = MockMvcBuilders.webAppContextSetup(this.wac);
		MockMvc mockMvc = builder.build();
		
		Acesso acesso = new Acesso();
		
		acesso.setDescricao("ROLE_BUSCAR_ACESSO_DESC");
		
		acesso = acessoRepository.save(acesso);
		
		ObjectMapper objectMapper = new ObjectMapper();
		
		ResultActions retornoApi = mockMvc
				.perform(MockMvcRequestBuilders.get("/buscarPorDesc/ACESSO_DESC")
				.content(objectMapper.writeValueAsString(acesso))
				.accept(MediaType.APPLICATION_JSON)
				.contentType(MediaType.APPLICATION_JSON));
		
		Assertions.assertEquals(200, retornoApi.andReturn().getResponse().getStatus());
		
		List<Acesso> acessoRetorno = objectMapper.readValue(
				retornoApi.andReturn().getResponse().getContentAsString(), 
				new TypeReference<List<Acesso>>() {});
		
		Assertions.assertEquals(1, acessoRetorno.size());
		
		acessoRepository.deleteById(acesso.getId());
	}
	
	@Test
	public void testCadastraAcesso() {
		
		Acesso acesso = new Acesso();
		
		acesso.setDescricao("ROLE_ALUNO");
		
		acesso = acessoController.salvarAcesso(acesso).getBody();
		
		Assertions.assertEquals(true, acesso.getId() > 0);
		
		Assertions.assertEquals("ROLE_ALUNO", acesso.getDescricao());
		
		List<Acesso> acessos = acessoRepository.buscarAcessoDesc("ALUNO".trim().toUpperCase());
		
		Assertions.assertEquals(1, acessos.size());
		
		acessoRepository.deleteById(acesso.getId());
	}

}
