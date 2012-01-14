# encoding: UTF-8

class MobilePronto
  class SendError < Exception
    attr_accessor :code

    # X01 ou X02 – Parâmetros com Erro. 
    # 000 - Mensagem enviada com Sucesso.
    # 001 - Credencial Inválida. 
    # 005 - Mobile fora do formato-Formato +999(9999)99999999
    # 007 - SEND_PROJECT tem que ser S,
    # 008 - Mensagem ou FROM+MESSAGE maior que 142 posições
    # 009 - Sem crédito para envio de SMS. Favor repor
    # 010 - Gateway Bloqueado. 
    # 012 - Mobile no formato padrão, mas incorreto
    # 013 - Mensagem Vazia ou Corpo Inválido
    # 015 - Pais sem operação. 
    # 016 - Mobile com tamanho do código de área inválido
    # 017 - Operadora não autorizada para esta Credencial
    # De 800 a 899 - Falha no gateway Mobile Pronto
    # 900 - Erro de autenticação ou Limite de segurança 
    # De 901 a 999 - Erro no acesso as operadoras.
    def initialize(code)
      self.code = code.strip
      if (code == "X01" || code == "X02")
        msg = "Parâmetros com Erro."
      else 
        msg = case(code.to_i)
          when   1 then "Credencial Inválida."
          when   5 then "Mobile fora do formato-Formato +999(9999)99999999."
          when   7 then "SEND_PROJECT tem que ser S ou N"
          when   8 then "Mensagem ou FROM+MESSAGE maior que 142 posições."
          when   9 then "Sem crédito para envio de SMS."
          when  10 then "Gateway Bloqueado."
          when  12 then "Mobile no formato padrão, mas incorreto."
          when  13 then "Mensagem Vazia ou Corpo Inválido."
          when  15 then "Pais sem operação."
          when  16 then "Mobile com tamanho do código de área inválido."
          when  17 then "Operadora não autorizada para esta Credencial."
          when 900 then "Erro de autenticação ou Limite de segurança"
          when 800..899 then "Falha no gateway Mobile Pronto"
          when 901..999 then "Erro no acesso as operadoras."
        end
      end
      
      super("#{self.code} - #{msg}")
    end
  end
end
