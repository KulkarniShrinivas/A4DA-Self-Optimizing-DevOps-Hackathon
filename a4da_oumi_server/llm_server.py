from flask import Flask, request, jsonify
from pydantic import BaseModel
from oumi_rl_agent import rl_agent

app = Flask(__name__)


class RewardSignal(BaseModel):
    reward_signal: float
    summary: str
    code_lore_narrative: str

@app.route('/reward', methods=['POST'])
def receive_reward():
    """
    Endpoint hit by the Kestra flow (send_reward_to_oumi task).
    Receives the structured JSON, validates it, and passes it to the RL Agent.
    """
    try:
        data = request.json

        
        signal_data = RewardSignal(**data)

      
        rl_agent.receive_reward(
            reward_signal=signal_data.reward_signal,
            summary=signal_data.summary,
            narrative=signal_data.code_lore_narrative
        )

       
        return jsonify({
            "status": "Reward received and processed.",
            "oumi_model_version": rl_agent.get_current_version()
        }), 200

    except Exception as e:
        print(f"Error processing request: {e}")
        return jsonify({"status": "Error", "message": str(e)}), 400

if __name__ == '__main__':
   
    app.run(host='0.0.0.0', port=5000)