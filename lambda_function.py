# lambda_function.py
# testing cicd
# to do: return token count

# 

# python built-ins

import sys
import os


import json
import logging



# imports (try/catch)
#import numpy
#import torch

import openai
import tiktoken




#try:
    
    #os.environ['TRANSFORMERS_CACHE'] = '/tmp/test_hf_transformers/'
    #import transformers

#except Exception as e:
    #print("cant load transformers: " + e)


"""
def handler(event, context):
    print("Event: ")
    print(event)

    print("\n\nContext: ")
    print(context)
    return 'running python: ' + sys.version + '!'"""


# Setup logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handler(event, context):
    # Log the received event

    logger.info("Received event: " + json.dumps(event, indent=2))
    
    # Generic message
    message = f"Running Python: {sys.version}. Event: {event}"

    logger.info("------------------------")
    logger.info(f"EVENT: {event}")
    logger.info(type(event))
    logger.info(f"EVENT: {event['body']}")
    logger.info(type(event['body']))
    logger.info(f"EVENT: {event['body']}")
    logger.info(type(event['body']))
    logger.info(f"PATH: {event['path']}")
    logger.info("------------------------")

    #logger.info(f'openai is installed with version {openai.__version__}')
    #logger.info(f'tiktoken is installed with version {tiktoken.__version__}')

    encoding = tiktoken.get_encoding("cl100k_base")

    encoding = tiktoken.encoding_for_model("gpt-3.5-turbo")

    encoding.encode("tiktoken is great!")

    def num_tokens_from_string(string: str, encoding_name: str) -> int:
        """Returns the number of tokens in a text string."""
        encoding = tiktoken.get_encoding(encoding_name)
        num_tokens = len(encoding.encode(string))
        return num_tokens

    logger.info(num_tokens_from_string("tiktoken is great!", "cl100k_base"))


    logger.info(encoding.decode([83, 1609, 5963, 374, 2294, 0]))



    # Return the message
    return {
        'statusCode': 200,
        'body': json.dumps({'message': f"{message} \n {json.dumps(event, indent=2)}"})
    }
