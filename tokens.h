/* 
*/

enum keywords
{
  INT=100,
  VAR,
  LONG,
  LONG_LONG,
  SHORT,
  SIGNED,
  UNSIGNED,
  GOTO,
  END,
  RETURN,
  EXIT,
  CHAR
};

enum operators
{
  DECREMENT=200,
  INCREMENT,
  PTR_SELECT,
  LOGICAL_AND,
  LOGICAL_OR,
  LS_THAN_EQ,
  GR_THAN_EQ,
  EQ,
  NOT_EQ,
  ASSIGN,
  MINUS,
  PLUS,
  STAR,
  LS_THAN,
  GR_THAN
};

enum special_symbols
{
  DELIMITER=300,
  COMMA,
  OPEN_PAR,
  CLOSE_PAR,
  FW_SLASH
};

enum constants
{
  DEC_CONSTANT=400,
  STRING
};

enum IDENTIFIER
{
  IDENTIFIER=500
};