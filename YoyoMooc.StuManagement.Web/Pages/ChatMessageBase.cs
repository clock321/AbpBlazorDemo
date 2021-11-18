using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.SignalR.Client;

namespace YoyoMooc.StuManagement.Web.Pages
{
	public class ChatMessageBase : ComponentBase
	{
		protected HubConnection _hubConnection;
		protected List<string> _messages = new List<string>();
		protected string _userInput;
		protected string _messageInput;

		[Inject]
		private NavigationManager NavigationManager { get; set; }

		protected async override Task OnInitializedAsync()
		{
			_hubConnection = new HubConnectionBuilder()
				.WithUrl(NavigationManager.ToAbsoluteUri("http://localhost/chatHub"))
				.Build();

			_hubConnection.On<string, string>("ReceiveMessage", (user, message) =>
			{
				var encodedMsg = $"{user}: {message}";
				_messages.Add(encodedMsg);
				StateHasChanged();
			});

			await _hubConnection.StartAsync();
		}

		protected async Task Send()
		{
			await _hubConnection.SendAsync("SendMessage", _userInput, _messageInput);
		}

		public bool IsConnected =>
			_hubConnection.State == HubConnectionState.Connected;
	}
}