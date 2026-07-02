package br.com.lojavirtual.security;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Date;

import javax.crypto.SecretKey;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import br.com.lojavirtual.ApplicationContextLoad;
import br.com.lojavirtual.model.Usuario;
import br.com.lojavirtual.repository.UsuarioRepository;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.SignatureException;

/*Criar a autenticacao e retornar a autenticacao JWT*/
@Service
public class JWTTokenAutenticacaoService {

    private final WebConfigSecurity webConfigSecurity;

	/*Token de validação*/
	private static final long EXPIRATION_TIME = 959990000; /*11 DIAS EM MILISEGUNDOS*/
	
	/* Chave de senha para juntar com JWT (Agora com 36 caracteres / >(32 bytes = 256 bits)) */
	private static final String SECRET = "378402&!@(#-90@)_+@!#$%%9hjs_SECURE_2026";
	
	private static final String TOKEN_PREFIX = "Bearer";
	
	private static final String HEADER_STRING = "Authorization";
	
	JWTTokenAutenticacaoService(){
		this.webConfigSecurity = new WebConfigSecurity();
	}

    JWTTokenAutenticacaoService(WebConfigSecurity webConfigSecurity) {
        this.webConfigSecurity = webConfigSecurity;
    }
	
	/*Gera o Token e da a resposta para o cliente com a JWT*/
	public void addAuthentication(HttpServletResponse response, String username) throws Exception{
		
		SecretKey key = Keys.hmacShaKeyFor(SECRET.getBytes(StandardCharsets.UTF_8));
		
		String jwt = Jwts.builder()
	            .subject(username) // Antigo setSubject()
	            .expiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME)) // Antigo setExpiration()
	            .signWith(key) // Antigo signWith(SignatureAlgorithm, String) - O algoritmo é detectado automaticamente pelo tamanho da chave
	            .compact();
		
		String token = TOKEN_PREFIX + " " + jwt;
		
		/*Dá a respota para a tela e para o cliente*/
		response.addHeader(HEADER_STRING, token);
		
		liberacaoCors(response);
		
		response.getWriter().write("{\"Authorization\": \""+ token +"\"}");
	}
	
	public Authentication getAuthentication(HttpServletResponse response, HttpServletRequest request) throws IOException {
		
		String token = request.getHeader(HEADER_STRING);
		
		try {
		
		if(token != null) {
			
			String tokenLimpo = token.replace(TOKEN_PREFIX, "").trim();
			
			SecretKey chaveObjeto = Keys.hmacShaKeyFor(SECRET.getBytes(StandardCharsets.UTF_8));
			
			String user = Jwts.parser()
			        .verifyWith(chaveObjeto)       // Usa a SecretKey configurada
			        .build()                       // Constrói o parser
			        .parseSignedClaims(tokenLimpo) // Passa o token
			        .getPayload()                  // Pega o corpo (antigo getBody)
			        .getSubject();
			
			if(user != null) {
				
				Usuario usuario = ApplicationContextLoad
						.getApplicationContext()
						.getBean(UsuarioRepository.class).findUserByLogin(user);
				
				if(usuario != null) {
					return new UsernamePasswordAuthenticationToken(
							usuario.getUsername(), 
							usuario.getPassword(),
							usuario.getAuthorities());
				}
			}
		}
		
		}catch (SignatureException e) {
			response.getWriter().write("Token está inválido!");
		}catch (ExpiredJwtException e) {
			response.getWriter().write("Token está expirado, efetue o login novamente!");
		}finally {
			liberacaoCors(response);
		}
		
		return null;
	}
	
	/*Fazendo liberação contra erro de CORS no navegador*/
	private void liberacaoCors(HttpServletResponse response) {
		
		if(response.getHeader("Access-Control-Allow-Origin") == null) {
			response.addHeader("Access-Control-Allow-Origin", "*");
		}
		
		if(response.getHeader("Access-Control-Allow-Headers") == null) {
			response.addHeader("Access-Control-Allow-Headers", "*");
		}
		
		if(response.getHeader("Access-Control-Request-Headers") == null) {
			response.addHeader("Access-Control-Request-Headers", "*");
		}
		
		if(response.getHeader("Access-Control-Allow-Methods") == null) {
			response.addHeader("Access-Control-Allow-Methods", "*");
		}
	}
}
